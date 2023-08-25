resource "aws_security_group" "private" {

  name        = "${var.env_code}-private"
  description = "Allow vpc traffic"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTPs from lb"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [var.load_balancer_sg]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_code}-private"
  }
}
