variable "bucket_id" {
  description = "The ID of the s3 bucket for storing Lambda artifacts"
  type        = string
}

variable "function_name" {
  description = "The name of the lambda"
  type        = string
}

variable "runtime" {
  description = "The lambda runtime"
  default     = "nodejs12.x"
  type        = string
}

variable "code_src" {
  description = "The lambda code source path"
  type        = string
}

variable "timeout" {
  description = "The lambda timeout"
  default     = 3
  type        = number
}

variable "handler" {
  description = "The lambda handler definition"
  default     = "dist/index.handler"
  type        = string
}

variable "publish" {
  description = "Whether or not to publish new version of lambda"
  default     = false
  type        = bool
}

variable "alias_name" {
  description = "The lambda alias name"
  type        = string
}

variable "alias_description" {
  description = "The description of the lambda alias"
  default     = ""
  type        = string
}

variable "log_retention" {
  description = "The log retention time"
  default     = 30
  type        = number
}

variable "iam_statements" {
  type = map(object({
    actions   = list(string)
    effect    = string
    resources = list(string)
  }))
  description = "The IAM Statements for the Lambda (runtime)"
  default     = null
}

variable "alias_iam_statements" {
  type = map(object({
    actions   = list(string)
    effect    = string
    resources = list(string)
  }))
  description = "The IAM Statements for the Lambda (runtime)"
  default     = null
}

variable "environment_vars" {
  description = "The environment variables for the Lambda Function"
  type        = map(string)
  default     = {}
}
