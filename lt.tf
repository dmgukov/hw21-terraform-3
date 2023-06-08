data "aws_ami" "amazonlinux2" {
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*-gp2"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners      = ["amazon"]
  most_recent = true
}

resource "aws_launch_template" "this" {
  name = "hillel-homework21-lt"

  instance_type = "t3.small"

  instance_market_options {
    market_type = "spot"
  }

  image_id = data.aws_ami.amazonlinux2.id

  user_data = filebase64("${path.module}/user_data.sh")

  key_name = "Main SSH Key"

  vpc_security_group_ids = module.sgroup.ec2_sgroup_id

  iam_instance_profile {
    name = aws_iam_role.ssm_role.name
  }
}

resource "aws_autoscaling_group" "this" {
  availability_zones = ["eu-central-1a"]
  desired_capacity   = 2
  max_size           = 5
  min_size           = 1

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_attachment" "this" {
  autoscaling_group_name = aws_autoscaling_group.this.id
  lb_target_group_arn    = module.loadbal.alb_tg_arn
}

resource "aws_iam_role" "ssm_role" {
  name = "ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "ec2-ssm-role"
  }
}

resource "aws_iam_role_policy_attachment" "ssm_role_policy_attachment" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_role" {
  name = "ec2-ssm-role"
  role = aws_iam_role.ssm_role.name
}