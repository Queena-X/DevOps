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
  name_prefix          = "${var.env_code}-web"
  image_id             = data.aws_ami.aws-linux.id
  instance_type        = var.instance_type
  security_group_names = [var.load_balancer_sg]
  user_data            = file("${path.module}/init.sh")
  iam_instance_profile {
    arn = aws_iam_instance_profile.ec2_profile.arn
  }
}

resource "aws_autoscaling_group" "bar" {
  availability_zones   = [var.aws_region]
  desired_capacity     = 1
  max_size             = 2
  min_size             = 1
  default_cooldown     = 300
  health_check_type    = "EC2"
  target_group_arns    = [var.target_group_arn]
  termination_policies = ["OldestLaunchTemplate"]
  vpc_zone_identifier  = [var.private_subnet_id]

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

}

