data "terraform_remote_state" "leve1" {
  backend = "s3"

  config = {
    bucket = "terraform-devops-learn"
    key    = "level1/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_ami" "aws-linux" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.1.20230725.0-kernel-6.1-x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
