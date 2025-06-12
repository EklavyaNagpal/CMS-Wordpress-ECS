output "db_endpoint" {
  description = "RDS endpoint address"
  value       = aws_db_instance.wordpress.endpoint
}

output "db_instance_id" {
  description = "RDS instance ID"
  value       = aws_db_instance.wordpress.id
}

output "secret_arn" {
  description = "ARN of the Secrets Manager secret containing DB credentials"
  value       = data.aws_secretsmanager_secret.db_credentials.arn
}

output "secret_name" {
  description = "Name of the Secrets Manager secret"
  value       = data.aws_secretsmanager_secret.db_credentials.name
}

output "secret_policy_arn" {
  description = "ARN of the IAM policy for secret access"
  value       = aws_iam_policy.rds_secret_access.arn
}
