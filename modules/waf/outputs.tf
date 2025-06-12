# output "web_acl_arn-alb" {
#   description = "ARN of the WAF Web ACL"
#   value       = aws_wafv2_web_acl.wordpress-alb.arn
# }

# output "web_acl_id-alb" {
#   description = "ID of the WAF Web ACL"
#   value       = aws_wafv2_web_acl.wordpress-alb.id
# }

output "web_acl_arn" {
  description = "ARN of the WAF Web ACL"
  value       = aws_wafv2_web_acl.wordpress-cloudfront.arn
}

output "web_acl_id-cloudfront" {
  description = "ID of the WAF Web ACL"
  value       = aws_wafv2_web_acl.wordpress-cloudfront.id
}

output "log_group_arn" {
  description = "ARN of the WAF log group"
  value       = try(aws_cloudwatch_log_group.waf[0].arn, null)
}
