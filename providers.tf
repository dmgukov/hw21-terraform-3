provider "aws" {
  region = "eu-central-1"
  default_tags {
    tags = {
      Hillel    = "Homework 21"
      Terraform = true
    }
  }
}
