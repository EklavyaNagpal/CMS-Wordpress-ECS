variable "env" {
  description = "Environment name"
  type        = string
}

# variable "alb_arn" {
#   description = "ARN of the ALB to associate with WAF"
#   type        = string
# }

variable "enable_logging" {
  description = "Enable WAF logging to CloudWatch"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "Number of days to retain WAF logs"
  type        = number
  default     = 30
}

variable "kms_key_arn" {
  description = "ARN of KMS key for encrypting logs"
  type        = string
  default     = null
}

variable "rate_limit" {
  description = "Request rate limit per 5 minutes"
  type        = number
  default     = 1000
}

# variable "web_acl_arn-alb" {}

# variable "web_acl_arn-cloudfront" {}

variable "cloudfront_arn" {
  description = "ARN of the CloudFront distribution to associate with WAF"
  type        = string
  default     = ""
}

# variable "web_acl_arn_alb" {
#   type = string
# }

# variable "web_acl_arn_cloudfront" {
#   type = string
# }
