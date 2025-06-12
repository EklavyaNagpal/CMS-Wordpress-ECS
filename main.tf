terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.4.3"
    }
  }

  backend "s3" {
    bucket         = "cybercx-cms" #Provide your Bucket Name, make sure it is created in AWS console before Terraform INIT
    key            = "wordpress-ecs/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Environment = var.env
      Terraform   = "true"
      Project     = "wordpress-cms"
    }
  }
}

# provider "random" {}
# resource "random_id" "log_bucket_suffix" {
#   byte_length = 4
# }

data "aws_caller_identity" "current" {}


# Networking Module - VPC, Subnets, Security Groups
module "networking" {
  source     = "./modules/networking"
  env        = var.env
  vpc_cidr   = var.vpc_cidr
  azs        = var.azs
  wordpress_port = var.wordpress_port
}

# EFS Module - Shared storage for WordPress content
module "efs" {
  source          = "./modules/efs"
  env             = var.env
  vpc_id          = module.networking.vpc_id
  private_subnets = module.networking.private_subnets
  security_groups = [module.networking.efs_sg_id]
}

# RDS Module - MySQL Database with Secrets Manager integration
module "rds" {
  source          = "./modules/rds"
  env             = var.env
  vpc_id          = module.networking.vpc_id
  private_subnets = module.networking.private_subnets
  security_groups = [module.networking.rds_sg_id]
  db_name         = var.db_name
  db_username     = var.db_username
  db_secret_arn   = "arn:aws:secretsmanager:us-east-1:891377392048:secret:cms-db-credentials-00-sI0e6u" # Provide ARN of Secrets Manager, make sure key should be username and password
  # db_password is now optional and handled within the RDS module
  instance_class       = var.rds_instance_class
  allocated_storage    = var.allocated_storage
  multi_az            = var.multi_az
  skip_final_snapshot = var.env == "prod" ? false : true
  # skip_final_snapshot = true
}

# ALB Module - Application Load Balancer
module "alb" {
  source          = "./modules/alb"
  env             = var.env
  vpc_id          = module.networking.vpc_id
  public_subnets  = module.networking.public_subnets
  security_groups = [module.networking.alb_sg_id]
  access_logs_bucket = var.alb_access_logs_bucket  # Add this line
  acm_certificate_arn = var.acm_certificate_arn    # Add this line if using HTTPS
}

# ECS Module - WordPress Containers
module "ecs" {
  source              = "./modules/ecs"
  env                 = var.env
  vpc_id              = module.networking.vpc_id
  private_subnets     = module.networking.private_subnets
  security_groups     = [module.networking.ecs_sg_id]
  alb_target_group    = module.alb.target_group_arn
  efs_id              = module.efs.efs_id
  db_name             = var.db_name
  db_secret_arn       = module.rds.secret_arn
  db_secret_policy_arn = module.rds.secret_policy_arn
  wordpress_image     = var.wordpress_image
  wordpress_port      = var.wordpress_port
  cpu                 = var.cpu
  memory              = var.memory
  desired_count       = var.desired_count
  log_retention_days  = var.log_retention_days

  depends_on = [
    module.rds,
    module.efs
  ]
}

module "waf" {
  source          = "./modules/waf"
  env             = var.env
  # alb_arn         = module.alb.alb_arn
  enable_logging  = var.enable_waf_logging
  log_retention_days = var.waf_log_retention_days
  # kms_key_arn     = var.waf_kms_key_arn
  rate_limit      = var.waf_rate_limit

  # web_acl_arn_alb        = aws_wafv2_web_acl.wordpress-alb.arn
  # waf_acl_arn = module.waf.web_acl_arn
  cloudfront_arn      = module.cloudfront.distribution_arn

  depends_on = [module.alb]
}


module "cloudwatch_monitoring" {
  source          = "./modules/cloudwatch"
  env             = var.env
  ecs_cluster_name = module.ecs.cluster_name
  ecs_service_name = module.ecs.service_name
  enable_alarms   = var.enable_cloudwatch_alarms
  alarm_actions   = [aws_sns_topic.alarm_notifications.arn]
}

resource "aws_sns_topic" "alarm_notifications" {
  name = "${var.env}-wordpress-alarms"
}

module "cloudfront" {
  source          = "./modules/cloudfront"
  env             = var.env
  alb_dns_name    = module.alb.alb_dns_name
  domain_name     = var.domain_name
  acm_certificate_arn = var.acm_certificate_arn
  waf_acl_arn = module.waf.web_acl_arn
  
  # Proper logging configuration
  #enable_logging  = var.enable_cloudfront_logging
  log_bucket      = var.cloudfront_log_bucket
}