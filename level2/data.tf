data "terraform_remote_state" "level1" {
  backend = "s3"

  config = {
    bucket = "terraform-devops-learn"
    key    = "level1/terraform.tfstate"
    region = "us-east-1"
  }
}

