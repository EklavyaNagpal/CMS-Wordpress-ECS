variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "env" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "wordpress"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "admin"
}

# Removed db_password from root variables since it's now handled by Secrets Manager

variable "wordpress_image" {
  description = "WordPress Docker image"
  type        = string
  default     = "wordpress:6.4.2-php8.2-apache" # Pinned version
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
  description = "Memory for ECS task"
  type        = number
  default     = 1024
}

variable "desired_count" {
  description = "Number of ECS tasks to run"
  type        = number
  default     = 2
}

variable "log_retention_days" {
  description = "CloudWatch log retention period in days"
  type        = number
  default     = 30
}

# RDS Configuration Variables
variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "RDS allocated storage in GB"
  type        = number
  default     = 20
}

variable "multi_az" {
  description = "Enable RDS Multi-AZ deployment"
  type        = bool
  default     = false # Set to true for production
}

# variable "log_retention_days" {
#   description = "CloudWatch log retention period in days"
#   type        = number
#   default     = 30
# }

variable "enable_cloudwatch_alarms" {
  description = "Enable CloudWatch alarms for ECS"
  type        = bool
  default     = true
}

variable "log_group_kms_key_arn" {
  description = "ARN of KMS key for CloudWatch log encryption"
  type        = string
  default     = null
}

variable "enable_waf" {
  description = "Enable AWS WAF protection"
  type        = bool
  default     = true
}

variable "enable_waf_logging" {
  description = "Enable WAF logging to CloudWatch"
  type        = bool
  default     = true
}

variable "waf_log_retention_days" {
  description = "Number of days to retain WAF logs"
  type        = number
  default     = 30
}

variable "waf_kms_key_arn" {
  description = "ARN of KMS key for WAF log encryption"
  type        = string
  default     = null
}

variable "waf_rate_limit" {
  description = "Request rate limit per 5 minutes"
  type        = number
  default     = 1000
}

variable "domain_name" {
  description = "Domain name for CloudFront distribution"
  type        = string
  default     = null
}

# variable "acm_certificate_arn" {
#   description = "ARN of ACM certificate for CloudFront"
#   type        = string
#   default     = null
# }

variable "enable_cloudfront_logging" {
  description = "Enable CloudFront logging"
  type        = bool
  default     = true
}

variable "cloudfront_log_bucket" {
  description = "S3 bucket for CloudFront logs"
  type        = string
  default     = null
}

variable "alb_access_logs_bucket" {
  description = "S3 bucket for ALB access logs"
  type        = string
  default     = null
}

variable "acm_certificate_arn" {
  description = "ARN of ACM certificate for HTTPS"
  type        = string
  default     = null  # Set to null if you're not using HTTPS
}

variable "alarm_email" {
  type        = string
  description = "Email address to send alarms to"
}

variable "efs_encrypted" {
  type        = bool
  description = "Whether to enable encryption for EFS"
  default     = true  # Optional: define a default
}
