module "sgroup" {
  source = "./modules/sgroup"

  alb_sg_name        = "hillel-homework21-alb-sg"
  alb_sg_description = "ALB SG for Hillel test project"

  ec2_sg_name        = "hillel-homework21-ec2-sg"
  ec2_sg_description = "EC2 SG for test project for Hillel"

  vpc_id = data.aws_vpc.default.id

}

module "loadbal" {
  source = "./modules/loadbal"

  alb_name = "hillel-homework21-alb"

  alb_sgroups = module.sgroup.alb_sgroup_id
  alb_subnets = data.aws_subnets.this.ids

  tg_name = "hillel-homework21-tg"

  vpc_id = data.aws_vpc.default.id
}

