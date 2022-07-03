# Infrastructure definitions

provider "aws" {
  version = "~> 2.0"
  region  = var.aws_region
}

# Local vars
locals {
  default_lambda_timeout = 10

  default_lambda_log_retention = 1
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket        = "lambda-bucket-assets-1234567"
  acl           = "private"
}

module "lambda_ingestion" {
  source               = "./modules/lambda"
  code_src             = "../functions/ingestion/main.zip"
  bucket_id            = aws_s3_bucket.lambda_bucket.id
  timeout              = local.default_lambda_timeout
  function_name        = "Ingestion-function"
  runtime              = "nodejs12.x"
  handler              = "dist/index.handler"
  publish              = true
  alias_name           = "ingestion-dev"
  alias_description    = "Alias for ingestion function"
  environment_vars = {
    DefaultRegion   = var.aws_region
  }
}

module "lambda_process_queue" {
  source               = "./modules/lambda"
  code_src             = "../functions/process-queue/main.zip"
  bucket_id            = aws_s3_bucket.lambda_bucket.id
  timeout              = local.default_lambda_timeout
  function_name        = "Process-Queue-function"
  runtime              = "nodejs12.x"
  handler              = "dist/index.handler"
  publish              = true
  alias_name           = "process-queue-dev"
  alias_description    = "Alias for ingestion function"
  environment_vars = {
    DefaultRegion   = var.aws_region
  }
}

data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}

### Github OIDC for Lambda
resource "aws_iam_openid_connect_provider" "github_actions" {
  client_id_list  = var.client_id_list
  thumbprint_list = [data.tls_certificate.github.certificates[0].sha1_fingerprint]
  url             = "https://token.actions.githubusercontent.com"
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "github_actions_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [
        format(
          "arn:aws:iam::%s:root",
          data.aws_caller_identity.current.account_id
        )
      ]
    }
  }

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type = "Federated"
      identifiers = [
        format(
          "arn:aws:iam::%s:oidc-provider/token.actions.githubusercontent.com",
          data.aws_caller_identity.current.account_id
        )
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.repo_name}:ref:refs/heads/master"]
    }
  }
}

resource "aws_iam_role" "github_actions" {
  name               = "github-actions"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role_policy.json
}

data "aws_iam_policy_document" "github_actions" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject",
    ]
    effect = "Allow"
    resources = [
      aws_s3_bucket.lambda_bucket.arn,
      "${aws_s3_bucket.lambda_bucket.arn}/*"
    ]
  }

  statement {
    actions = [
      "lambda:updateFunctionConfiguration",
      "lambda:updateFunctionCode",
      "lambda:updateAlias",
      "lambda:publishVersion",
    ]
    effect = "Allow"
    resources = [
      module.lambda_ingestion.lambda[0].arn,
      module.lambda_process_queue.lambda[0].arn
    ]
  }
}

resource "aws_iam_role_policy" "github_actions" {
  name   = "github-actions"
  role   = aws_iam_role.github_actions.id
  policy = data.aws_iam_policy_document.github_actions.json
}
