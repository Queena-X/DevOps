resource "aws_security_group" "rds" {

  name        = "rds"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.terraform_remote_state.leve1.outputs.vpc_id

  ingress {
    description     = "SSH alb private instance"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_lb.public-alb.id]
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




