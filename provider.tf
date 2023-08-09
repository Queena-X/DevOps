terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "terraform-devops-learn"
    key    = "myapp/dev/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-devops"
  }
}

provider "aws" {
  region = var.aws_region
}
