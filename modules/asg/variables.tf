variable "aws_region" {
  default = "us-east-1"
}

variable "env_code" {
  type = string
}

variable "ami" {
  type    = string
  default = "ami-0f34c5ae932e6f0e4"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "private_subnet_id" {}

variable "vpc_id" {}

variable "load_balancer_sg" {}

variable "target_group_arn" {}

