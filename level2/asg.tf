resource "aws_launch_template" "web" {
  name_prefix          = "${var.env_code}-web"
  image_id             = data.aws_ami.aws-linux.id
  instance_type        = var.instance_type
  security_group_names = [aws_security_group.web]
  key_name             = "main"
  user_data            = file("init.sh")
}

resource "aws_autoscaling_group" "bar" {
  availability_zones   = [var.aws_region]
  desired_capacity     = 1
  max_size             = 2
  min_size             = 1
  default_cooldown     = 300
  health_check_type    = "EC2"
  target_group_arns    = [aws_lb_target_group.ec2-alb-tg.arn]
  termination_policies = ["OldestLaunchTemplate"]
  vpc_zone_identifier  = [data.terraform_remote_state.leve1.outputs.private_subnet_id]

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag = {
    Name = "web-asg"
  }
}
