resource "aws_efs_file_system" "wordpress" {
  creation_token = "${var.env}-wordpress-efs"
  encrypted      = true
  tags = {
    Name = "${var.env}-wordpress-efs"
  }
}

resource "aws_efs_mount_target" "wordpress" {
  count           = length(var.private_subnets)
  file_system_id  = aws_efs_file_system.wordpress.id
  subnet_id       = var.private_subnets[count.index]
  security_groups = var.security_groups
}