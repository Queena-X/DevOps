resource "aws_security_group" "alb-sg" {

  name        = "alb-sg"
  description = "Allow http inbound traffic"
  vpc_id      = data.terraform_remote_state.leve1.outputs.vpc_id

  ingress {
    description = "HTTP ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "http"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_code}-load-balancer"
  }
}

resource "aws_lb" "public-alb" {
  name               = "public-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = [for subnet in data.terraform_remote_state.leve1.outputs.public_subnet_id : subnet.id]

  enable_deletion_protection = false

  tags = {
    Name = var.env_code
  }
}

resource "aws_lb_target_group" "ec2-alb-tg" {
  name     = "ec2-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.leve1.outputs.vpc_id

  health_check {
    enabled             = true
    path                = "/"
    port                = "traffic-port"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 20
    matcher             = "200"
  }
}

resource "aws_lb_listener" "back-end" {
  load_balancer_arn = aws_lb.public-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2-alb-tg.arn
  }
}


