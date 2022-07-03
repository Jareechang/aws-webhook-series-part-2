output "lambda" {
  value = aws_lambda_function.this[*]
}

output "alias" {
  value = aws_lambda_alias.this[*]
}

output "log_group" {
  value = aws_cloudwatch_log_group.log_group[*]
}
