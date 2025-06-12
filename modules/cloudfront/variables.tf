variable "env" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "domain_name" {
  description = "Custom domain name for CloudFront distribution"
  type        = string
  default     = null
}

variable "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  type        = string
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate for CloudFront"
  type        = string
}

variable "log_bucket" {
  description = "S3 bucket for CloudFront logs (must be in us-east-1)"
  type        = string
}

variable "waf_acl_arn" {
  description = "ARN of the WAFv2 Web ACL"
  type        = string
}

variable "enable_waf" {
  description = "Enable Lambda@Edge for WAF header injection"
  type        = bool
  default     = false
}

variable "enable_logging" {
  description = "Whether to enable CloudFront access logging"
  type        = bool
  default     = false
}

# variable "log_bucket" {
#   description = "S3 bucket for CloudFront logs"
#   type        = string
#   default     = null
# }