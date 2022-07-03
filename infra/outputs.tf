# Output value definitions

output "lambda_bucket_name" {
  description = "Name of the S3 bucket used to store function code."
  value = aws_s3_bucket.lambda_bucket.id
}

output "function_name_ingestion" {
  description = "Name of function"
  value = module.lambda_ingestion.lambda[0].function_name
}

output "function_alias_name_ingestion" {
  description = "Name of the function alias"
  value = module.lambda_ingestion.alias[0].name
}

output "function_name_process_queue" {
  description = "Name of function"
  value = module.lambda_process_queue.lambda[0].function_name
}

output "function_alias_name_process_queue" {
  description = "Name of the function alias"
  value = module.lambda_process_queue.alias[0].name
}

output "role_arn" {
  value = aws_iam_role.github_actions.arn
}
