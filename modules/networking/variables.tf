variable "env" {
  description = "Environment name (e.g., prod, dev)"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

variable "wordpress_port" {
  description = "Port WordPress container listens on"
  type        = number
  default     = 80
}