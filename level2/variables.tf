variable "aws_region" {
  default = "us-east-1"
}

variable "env_code" {
  type = string
}

variable "vpc_cidr" {
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

