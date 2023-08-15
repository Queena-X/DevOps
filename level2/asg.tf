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

resource "aws_launch_template" "web" {
  name_prefix   = "web"
  image_id      = data.aws_ami.aws-linux.id
  instance_type = "t2.micro"
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

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag = {
    Name = "web-asg"
  }
}