# Add this at the top of your ECS module, with other data sources
data "aws_region" "current" {}

resource "aws_ecs_cluster" "main" {
  name = "${var.env}-wordpress-cluster"
  tags = {
    Name = "${var.env}-wordpress-cluster"
  }
}

resource "aws_ecs_task_definition" "wordpress" {
  family                   = "${var.env}-wordpress-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([{
    name      = "wordpress"
    image     = var.wordpress_image
    essential = true
    portMappings = [{
      containerPort = var.wordpress_port
      hostPort      = var.wordpress_port
    }]
    environment = [
      { name = "WORDPRESS_DB_NAME", value = var.db_name }
    ]
    secrets = [
      {
        name      = "WORDPRESS_DB_HOST",
        valueFrom = "${var.db_secret_arn}:host::"
      },
      {
        name      = "WORDPRESS_DB_USER",
        valueFrom = "${var.db_secret_arn}:username::"
      },
      {
        name      = "WORDPRESS_DB_PASSWORD",
        valueFrom = "${var.db_secret_arn}:password::"
      }
    ]
    mountPoints = [{
      sourceVolume  = "wordpress-content"
      containerPath = "/var/www/html/wp-content"
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.wordpress.name
        "awslogs-region"        = data.aws_region.current.name
        "awslogs-stream-prefix" = "wordpress"
        # "awslogs-create-group"   = "false",
        "awslogs-datetime-format" = "%Y-%m-%dT%H:%M:%S.%f%z"
      }
    }
  }])

  volume {
    name = "wordpress-content"
    efs_volume_configuration {
      file_system_id     = var.efs_id
      root_directory     = "/"
      transit_encryption = "ENABLED"
    }
  }
}

resource "aws_ecs_service" "wordpress" {
  name            = "${var.env}-wordpress-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.wordpress.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 50

  network_configuration {
    security_groups = var.security_groups
    subnets         = var.private_subnets
  }

  load_balancer {
    target_group_arn = var.alb_target_group
    container_name   = "wordpress"
    container_port   = var.wordpress_port
  }

  depends_on = [
    aws_iam_role_policy_attachment.ecs_task_execution_role,
    aws_iam_role_policy_attachment.ecs_task_secret_access
  ]
}

# ECS Task Execution Role
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.env}-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS Task Role
resource "aws_iam_role" "ecs_task_role" {
  name = "${var.env}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

# Attach the secret access policy to the task role
resource "aws_iam_role_policy_attachment" "ecs_task_secret_access" {
  role       = [aws_iam_role.ecs_task_role.name, aws_iam_role.ecs_task_execution_role.name]
  policy_arn = var.db_secret_policy_arn
}


# CloudWatch Logs
# resource "aws_cloudwatch_log_group" "wordpress" {
#   name              = "/ecs/${var.env}-wordpress"
#   retention_in_days = var.log_retention_days
# }

# data "aws_region" "current" {}

resource "aws_cloudwatch_log_group" "wordpress" {
  name              = "/ecs/${var.env}-wordpress"
  retention_in_days = var.log_retention_days
  kms_key_id        = var.log_group_kms_key_arn
  
  tags = {
    Environment = var.env
    Application = "wordpress"
  }
}

resource "aws_iam_policy" "cloudwatch_logs" {
  name        = "${var.env}-ecs-cloudwatch-logs"
  description = "Allows ECS tasks to write to CloudWatch Logs"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ],
        Resource = "${aws_cloudwatch_log_group.wordpress.arn}:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_cloudwatch_logs" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.cloudwatch_logs.arn
}