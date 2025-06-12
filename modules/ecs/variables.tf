variable "env" {
  description = "Environment name (e.g., prod, dev)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "security_groups" {
  description = "List of security group IDs for ECS tasks"
  type        = list(string)
}

variable "alb_target_group" {
  description = "ALB target group ARN"
  type        = string
}

variable "efs_id" {
  description = "EFS filesystem ID"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_secret_arn" {
  description = "ARN of the Secrets Manager secret containing DB credentials"
  type        = string
}

variable "db_secret_policy_arn" {
  description = "ARN of the IAM policy for secret access"
  type        = string
}

variable "wordpress_image" {
  description = "WordPress Docker image"
  type        = string
  default     = "wordpress:6.4.2-php8.2-apache"
}

variable "wordpress_port" {
  description = "WordPress container port"
  type        = number
  default     = 80
}

variable "cpu" {
  description = "CPU units for ECS task"
  type        = number
  default     = 512
}

variable "memory" {
  description = "Memory for ECS task (MB)"
  type        = number
  default     = 1024
}

variable "desired_count" {
  description = "Number of ECS tasks to run"
  type        = number
  default     = 2
}

variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 30
}

variable "enable_ecr_access" {
  description = "Whether to enable ECR access for tasks"
  type        = bool
  default     = true
}

# variable "log_retention_days" {
#   description = "Number of days to retain CloudWatch logs"
#   type        = number
#   default     = 30
# }

variable "log_group_kms_key_arn" {
  description = "ARN of KMS key to encrypt CloudWatch logs (optional)"
  type        = string
  default     = null
}

variable "enable_cloudwatch_logs" {
  description = "Whether to enable CloudWatch logging"
  type        = bool
  default     = true
}