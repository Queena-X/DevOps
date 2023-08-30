module "asg_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.env_code}-asg-sg"
  vpc_id = data.terraform_remote_state.level1.outputs.vpc_id

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.service_sg.security_group_id
    }
  ]

  number_of_computed_ingress_with_source_security_group_id = 1

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

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

module "asg" {
  source = "terraform-aws-modules/autoscaling/aws"

  # Autoscaling group
  name = "${var.env_code}-asg"

  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  health_check_grace_period = 400
  vpc_zone_identifier       = data.terraform_remote_state.level1.outputs.private_subnet_id
  target_group_arns         = module.alb.target_group_arns
  force_delete              = true

  # Launch template
  launch_template_name        = "example-asg"
  launch_template_description = "Launch template example"
  update_default_version      = true
  launch_template_version     = "$Latest"

  image_id        = data.aws_ami.aws-linux.id
  instance_type   = var.instance_type
  key_name        = "main"
  security_groups = [module.service_sg.security_group_id]
  user_data       = filebase64("$init.sh")

  # IAM role & instance profile
  create_iam_instance_profile = true
  iam_role_name               = var.env_code
  iam_role_path               = "/ec2/"
  iam_role_description        = "IAM role SSM"
  iam_role_tags = {
    CustomIamRole = "No"
  }
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
}
