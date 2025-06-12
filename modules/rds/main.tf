resource "aws_db_subnet_group" "main" {
  name       = "${var.env}-db-subnet-group"
  subnet_ids = var.private_subnets
  tags = {
    Name = "${var.env}-db-subnet-group"
  }
}

data "aws_secretsmanager_secret" "db_credentials" {
  arn = var.db_secret_arn
}

data "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = data.aws_secretsmanager_secret.db_credentials.id
}

locals {
  db_creds = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string)
}

resource "aws_db_instance" "wordpress" {
  identifier             = "${var.env}-wordpress-db"
  engine                = "mysql"
  engine_version        = var.engine_version
  instance_class        = var.instance_class
  allocated_storage     = var.allocated_storage
  storage_type          = var.storage_type
  db_name               = var.db_name
  username              = local.db_creds.username
  password              = local.db_creds.password
  parameter_group_name  = var.parameter_group_name
  db_subnet_group_name  = aws_db_subnet_group.main.name
  vpc_security_group_ids = var.security_groups
  skip_final_snapshot   = var.skip_final_snapshot
  multi_az              = var.multi_az
  publicly_accessible   = false
  
  tags = {
    Name = "${var.env}-wordpress-db"
  }
}

# IAM policy to allow ECS tasks to read the secret
resource "aws_iam_policy" "rds_secret_access" {
  name        = "${var.env}-wordpress-rds-secret-access"
  description = "Allows ECS tasks to read RDS credentials"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Effect   = "Allow"
        Resource = data.aws_secretsmanager_secret.db_credentials.arn
      }
    ]
  })
}




########################################## Below Code is to create secrets from Terraform ###################################

# # Create the secret in Secrets Manager
# resource "aws_secretsmanager_secret" "db_credentials" {
#   name                    = "${var.env}/wordpress/rds/credentials"
#   description             = "Credentials for WordPress RDS instance"
#   recovery_window_in_days = 0 # Set to 0 for immediate deletion (use 7-30 in production)

#   tags = {
#     Environment = var.env
#     Application = "wordpress"
#   }
# }

# # Generate a random password if one isn't provided
# resource "random_password" "db_password" {
#   length           = 16
#   special          = true
#   override_special = "!#$%&*()-_=+[]{}<>:?"
# }

# # Store the credentials in Secrets Manager
# resource "aws_secretsmanager_secret_version" "db_credentials" {
#   secret_id = aws_secretsmanager_secret.db_credentials.id
#   secret_string = jsonencode({
#     username = var.db_username
#     password = coalesce(var.db_password, random_password.db_password.result)
#     engine   = "mysql"
#     host     = aws_db_instance.wordpress.address
#     port     = "3306"
#     dbname   = var.db_name
#   })
# }

# data "aws_secretsmanager_secret_version" "db_credentials" {
#   secret_id = var.db_secret_name
# }

# locals {
#   db_creds = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string)
# }
####################################################################################################################


# resource "aws_db_instance" "wordpress" {
#   identifier             = "${var.env}-wordpress-db"
#   engine                = "mysql"
#   engine_version        = var.engine_version
#   instance_class        = var.instance_class
#   allocated_storage     = var.allocated_storage
#   storage_type          = var.storage_type
#   db_name               = var.db_name
#   username              = var.db_username
#   password              = coalesce(var.db_password, random_password.db_password.result)
#   # username              = local.db_creds["username"]
#   # password              = local.db_creds["password"]
#   parameter_group_name  = var.parameter_group_name
#   db_subnet_group_name  = aws_db_subnet_group.main.name
#   vpc_security_group_ids = var.security_groups
#   skip_final_snapshot   = var.skip_final_snapshot
#   multi_az              = var.multi_az
#   publicly_accessible   = false
#   tags = {
#     Name = "${var.env}-wordpress-db"
#   }

#   # Ensure secret is created before RDS instance
#   # depends_on = [aws_secretsmanager_secret_version.db_credentials]
# }