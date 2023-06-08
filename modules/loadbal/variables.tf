variable "alb_name" {
  type = string
}

variable "alb_sgroups" {
  type = list(string)
}

variable "alb_subnets" {
  type = list(string)
}

variable "tg_name" {
  type = string
}

variable "vpc_id" {
  type = string
}