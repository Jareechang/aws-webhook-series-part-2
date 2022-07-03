resource "aws_s3_bucket_object" "lambda_default" {
  bucket = var.bucket_id
  key    = "main-${uuid()}.zip"
  source = var.code_src
  etag = filemd5(var.code_src)
}

resource "aws_lambda_function" "this" {
  function_name    = var.function_name
  s3_bucket        = var.bucket_id
  s3_key           = aws_s3_bucket_object.lambda_default.key
  runtime          = var.runtime
  handler          = var.handler
  publish          = var.publish
  source_code_hash = "${filebase64sha256(var.code_src)}"
  role             = aws_iam_role.lambda_exec.arn
  dynamic "environment" {
    for_each = length(keys(var.environment_vars)) == 0 ? [] : [true]
    content {
      variables = var.environment_vars
    }
  }
}

resource "aws_lambda_alias" "this" {
  name             = var.alias_name
  description      = var.alias_description != "" ? var.alias_description : "description ${var.alias_name}"
  function_name    = aws_lambda_function.this.arn
  function_version = aws_lambda_function.this.version
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "/aws/lambda/${aws_lambda_function.this.function_name}"
  retention_in_days = var.log_retention
}

resource "aws_iam_role" "lambda_exec" {
  name               = "${lower(var.function_name)}-exec-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Sid       = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

data "aws_iam_policy_document" "runtime_policy_doc" {
  version = "2012-10-17"
  statement {
      actions = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
      ]
      effect = "Allow"
      resources = [
        "*"
      ]
  }
  dynamic "statement" {
    for_each = var.iam_statements != null ? var.iam_statements : {}
    content {
      actions   = statement.value["actions"]
      effect    = statement.value["effect"]
      resources = statement.value["resources"]
    }
  }
}

resource "aws_iam_policy" "lambda_runtime_policy" {
  name = "${lower(var.function_name)}-runtime-policy"
  policy = data.aws_iam_policy_document.runtime_policy_doc.json
}

resource "aws_iam_policy_attachment" "attach_policy_to_role_lambda" {
  name       = "${lower(var.function_name)}-lambda-role-attachment"
  roles      = [aws_iam_role.lambda_exec.name]
  policy_arn = aws_iam_policy.lambda_runtime_policy.arn
}
