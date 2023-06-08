output "alb_sgroup_id" {
  value = [aws_security_group.this.id]
}

output "ec2_sgroup_id" {
  value = [aws_security_group.instance.id]
}
    