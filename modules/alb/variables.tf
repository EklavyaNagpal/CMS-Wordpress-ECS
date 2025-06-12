variable "env" {
  description = "Environment name (e.g., prod, dev)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "security_groups" {
  description = "List of security group IDs for ALB"
  type        = list(string)
}

variable "access_logs_bucket" {
  description = "S3 bucket name for storing ALB access logs"
  type        = string
}

variable "acm_certificate_arn" {
  description = "ARN of ACM certificate for HTTPS"
  type        = string
  default     = null  # Set to null if you're not using HTTPS
}