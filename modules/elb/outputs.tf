output "load_balancer_sg" {
  value = aws_security_group.alb-sg.id
}

output "target_group_arn" {
  value = aws_lb_target_group.ec2-alb-tg.arn
}