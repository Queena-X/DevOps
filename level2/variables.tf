variable "aws_region" {
  default = "us-east-1"
}

variable "env_code" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "private_subnet_id" {}

variable "vpc_id" {}

variable "load_balancer_sg" {}

variable "target_group_arn" {}

variable "domain_name" {
  default = "devopsexample111.com"
}

variable "record_name" {
  default = "www"
}

variable "dbname" {
  default = "dbname"
}

variable "username" {
  default = "database-dev"
}

variable "rds_password" {}



