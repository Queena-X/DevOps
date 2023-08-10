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

resource "aws_instance" "web" {
  ami                         = data.aws_ami.aws-linux.id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  key_name                    = "main"
  vpc_security_group_ids      = [aws_security_group.web.id]
  subnet_id                   = data.terraform_remote_state.leve1.outputs.public_subnet_id[0]
  user_data                   = file("init.sh")

  tags = {
    Name = "${var.env_code}-web"
  }
}

resource "aws_security_group" "web" {

  name        = "web"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.terraform_remote_state.leve1.outputs.vpc_id

  ingress {
    description = "SSH from PUBLIC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["108.255.250.119/32"]
  }

  ingress {
    description = "HTTP ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "http"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web"
  }
}

resource "aws_instance" "rds" {
  ami                         = data.aws_ami.aws-linux.id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  key_name                    = "main"
  vpc_security_group_ids      = [aws_security_group.rds.id]
  subnet_id                   = data.terraform_remote_state.leve1.outputs.private_subnet_id[0]
  user_data                   = file("init.sh")

  tags = {
    Name = "${var.env_code}-rds"
  }
}

resource "aws_security_group" "rds" {

  name        = "rds"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.terraform_remote_state.leve1.outputs.vpc_id

  ingress {
    description = "SSH from private instance"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds"
  }
}



