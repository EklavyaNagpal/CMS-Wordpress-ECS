output "efs_id" {
  description = "EFS filesystem ID"
  value       = aws_efs_file_system.wordpress.id
}

output "efs_dns_name" {
  description = "EFS DNS name"
  value       = aws_efs_file_system.wordpress.dns_name
}

output "mount_target_ids" {
  description = "List of mount target IDs"
  value       = aws_efs_mount_target.wordpress[*].id
}