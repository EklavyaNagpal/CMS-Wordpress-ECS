output "alb_dns_name" {
  description = "ALB DNS name for accessing WordPress"
  value       = module.alb.alb_dns_name
}

output "db_endpoint" {
  description = "RDS endpoint (for administrative purposes)"
  value       = module.rds.db_endpoint
  sensitive   = true
}

output "efs_id" {
  description = "EFS filesystem ID"
  value       = module.efs.efs_id
}

output "db_secret_arn" {
  description = "ARN of the database credentials secret"
  value       = module.rds.secret_arn
  sensitive   = true
}

output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = module.ecs.cluster_name
}

output "ecs_service_name" {
  description = "ECS service name"
  value       = module.ecs.service_name
}

output "cloudwatch_log_group" {
  description = "CloudWatch log group for WordPress containers"
  value       = module.ecs.log_group_name
}

output "secret_access_policy_arn" {
  description = "IAM policy ARN for accessing database secrets"
  value       = module.rds.secret_policy_arn
}

# Additional useful outputs
output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.networking.vpc_id
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.networking.private_subnets
}

output "alarm_sns_topic" {
  description = "SNS topic for alarm notifications"
  value       = aws_sns_topic.alarm_notifications.arn
}

# output "waf_acl_arn" {
#   description = "WAF Web ACL ARN"
#   value       = module.waf.web_acl_arn
# }

# output "waf_log_group_arn" {
#   description = "WAF log group ARN"
#   value       = module.waf.log_group_arn
# }
