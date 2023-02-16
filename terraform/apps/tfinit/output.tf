output "tfbucket" {
  description = "TF Bucket Name"
  value       = aws_s3_bucket.tfbucket.id
}

output "lock_table" {
  description = "Dynamodb Locktable"
  value       = aws_dynamodb_table.action_locktable.name
}