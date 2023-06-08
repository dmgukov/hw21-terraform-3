locals {
  my_public_ip = lookup(data.external.my_ip.result, "ip", "127.0.0.1")
}

resource "aws_security_group" "this" {
  name        = var.alb_sg_name
  description = var.alb_sg_description

  vpc_id = var.vpc_id
  tags = {
    Name = var.alb_sg_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.this.id

  description = "Allow HTTP for me"
  cidr_ipv4   = "${local.my_public_ip}/32"
  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80
}

resource "aws_vpc_security_group_egress_rule" "egress_http" {
  security_group_id = aws_security_group.this.id

  referenced_security_group_id = aws_security_group.instance.id
  description                  = "Allow egress for all"
  ip_protocol                  = "tcp"
  from_port                    = 8080
  to_port                      = 8080
}

resource "aws_security_group" "instance" {
  name        = var.ec2_sg_name
  description = var.ec2_sg_description

  vpc_id = var.vpc_id
  tags = {
    Name = var.ec2_sg_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "instance_ssh" {
  security_group_id = aws_security_group.instance.id

  description = "Allow SSH for me"
  cidr_ipv4   = "${local.my_public_ip}/32"
  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.instance.id

  description                  = "Allow HTTP for ALB"
  referenced_security_group_id = aws_security_group.this.id
  ip_protocol                  = "tcp"
  from_port                    = 8080
  to_port                      = 8080
}

resource "aws_vpc_security_group_egress_rule" "instance_all" {
  security_group_id = aws_security_group.instance.id

  description = "Allow egress for all"
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = -1
}
