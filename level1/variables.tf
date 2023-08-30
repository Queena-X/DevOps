variable "aws_region" {
  default = "us-east-1"
}

variable "env_code" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "private_cidr" {
  type = list(any)
}

variable "public_cidr" {
  type = list(any)
}



