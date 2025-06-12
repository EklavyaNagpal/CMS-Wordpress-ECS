output "high_cpu_alarm_arn" {
  description = "ARN of the high CPU alarm"
  value       = try(aws_cloudwatch_metric_alarm.high_cpu[0].arn, null)
}

output "high_memory_alarm_arn" {
  description = "ARN of the high memory alarm"
  value       = try(aws_cloudwatch_metric_alarm.high_memory[0].arn, null)
}