resource "aws_instance" "web" {
  ami             = var.ami
  instance_type   = var.instance_type
  associate_public_ip_address = true
  key_name="main"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  subnet_id = aws_subnet.public[0].id

  tags = {
    Name = "${var.env_code}-web"
  }
}

resource "aws_security_group" "allow_tls" {

  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from PUBLIC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks      = ["108.255.250.119/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
