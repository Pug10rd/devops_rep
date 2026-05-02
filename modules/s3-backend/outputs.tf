output "s3_bucket_name" {
  description = "Назва S3-бакета для стейтів"
  #value       = s3_backend.s3_bucket_name
  value = aws_s3_bucket.terraform_state.id
}

output "dynamodb_table_name" {
  description = "Назва таблиці DynamoDB для блокування стейтів"
  #value       = s3_backend.dynamodb_table_name
  value = aws_dynamodb_table.terraform_locks.name
}