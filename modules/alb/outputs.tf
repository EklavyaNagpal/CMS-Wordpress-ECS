output "alb_dns_name" {
  description = "ALB DNS name"
  value       = aws_lb.wordpress.dns_name
}

output "alb_arn" {
  description = "ALB ARN"
  value       = aws_lb.wordpress.arn
}

output "target_group_arn" {
  description = "Target group ARN"
  value       = aws_lb_target_group.wordpress.arn
}