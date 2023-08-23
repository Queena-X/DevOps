variable "env_code" {
  type = string
}

variable "vpc_id" {}

variable "public_subnet_id" {}

variable "domain_name" {
  default = "devopsexample111.com"
}

variable "record_name" {
  default = "www"
}

