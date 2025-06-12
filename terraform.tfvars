alarm_email          = "alerts@example.com"


# # ======================
# # Global Configuration
# # ======================
# region = "us-east-1"
# env    = "prod"

# # ======================
# # Networking Configuration
# # ======================
# vpc_cidr           = "10.0.0.0/16"
# azs                = ["us-east-1a", "us-east-1b"]

# # ======================
# # ECS Configuration
# # ======================
# wordpress_image    = "wordpress:6.4.2-php8.2-apache"  # Pinned version for stability
# wordpress_port     = 80
# cpu                = 512    # 0.5 vCPU
# memory             = 1024   # 1GB RAM
# desired_count      = 2      # Number of tasks

# # ======================
# # RDS Configuration (Secrets Manager)
# # ======================
# db_name          = "wordpress"
# db_username      = "admin"  # Will be stored in Secrets Manager
# rds_instance_class = "db.t3.micro"
# allocated_storage  = 20
# multi_az           = false  # Set to true for production

# # Secrets Manager configuration
# db_secret_name = "/prod/wordpress/rds/credentials"  # Secrets Manager path

# # ======================
# # ALB Configuration
# # ======================
# # alb_access_logs_bucket = "cms-alb-access-logs-${random_id.log_bucket_suffix.hex}"
# alb_access_logs_bucket = "cms-alb-access-logs"
acm_certificate_arn    = "arn:aws:acm:us-east-1:891377392048:certificate/634406cf-dfb9-4b90-920d-94a0fab17ba2"

# # ======================
# # WAF Configuration
# # ======================
# enable_waf            = true
# enable_waf_logging    = true
# waf_log_retention_days = 30
# waf_rate_limit        = 1000  # Requests per 5 minutes per IP
# # waf_kms_key_arn       = "arn:aws:kms:us-east-1:123456789012:key/xxxxxx"

# # ======================
# # CloudFront Configuration
# # ======================
domain_name          = "datacloudapp.net"
enable_cloudfront_logging = true
# # cloudfront_log_bucket = "cms-cloudfront-logs-${random_id.log_bucket_suffix.hex}"
cloudfront_log_bucket = "cms-cloudfront-logs"

# # ======================
# # CloudWatch Configuration
# # ======================
# log_retention_days    = 30  # Days to retain logs
# enable_cloudwatch_alarms = true


# # ======================
# # EFS Configuration
# # ======================
# efs_throughput_mode  = "bursting"  # Or "provisioned" for predictable performance
# efs_encrypted        = true

# # ======================
# # Tags
# # ======================
# # tags = {
# #   Project     = "wordpress-cms"
# #   ManagedBy   = "terraform"
# #   Environment = "prod"
# #   Owner       = "devops-team"
# # }

# # Random suffix for log buckets to ensure global uniqueness
# # resource "random_id" "log_bucket_suffix" {
# #   byte_length = 4
# # }