# cloudfront/main.tf
resource "aws_cloudfront_distribution" "wordpress" {
  enabled             = true
  aliases             = var.domain_name != null ? [var.domain_name] : null
  default_root_object = "index.php"
  price_class         = "PriceClass_100" # US/Europe only

  origin {
    domain_name = var.alb_dns_name
    origin_id   = "alb-origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "alb-origin"

    forwarded_values {
      query_string = true
      headers      = ["Host", "Origin", "Referer"]

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true

    dynamic "lambda_function_association" {
      for_each = var.enable_waf ? [1] : []
      content {
        event_type   = "viewer-request"
        lambda_arn   = aws_lambda_function.waf_header[0].qualified_arn
        include_body = false
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
dynamic "logging_config" {
  for_each = var.enable_logging ? [1] : []
  content {
    bucket          = var.log_bucket
    include_cookies = false
    prefix          = var.env
  }
}
  # logging_config {
  #   bucket          = var.log_bucket
  #   include_cookies = false
  #   prefix          = var.env
  #   #enabled         = var.enable_logging
  # }

  web_acl_id = var.waf_acl_arn

  tags = {
    Environment = var.env
  }
}

data "aws_caller_identity" "current" {}


resource "aws_lambda_function" "waf_header" {
  count = var.enable_waf ? 1 : 0

  filename      = "${path.module}/lambda/waf-header.zip"
  function_name = "${var.env}-waf-header"
  role          = aws_iam_role.lambda[0].arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"
  publish       = true

  tags = {
    Environment = var.env
  }
}

resource "aws_iam_role" "lambda" {
  count = var.enable_waf ? 1 : 0

  name = "${var.env}-waf-header-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  count = var.enable_waf ? 1 : 0

  role       = aws_iam_role.lambda[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}