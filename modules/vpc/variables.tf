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


