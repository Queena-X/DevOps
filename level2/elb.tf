data "aws_route53_zone" "hosted_zone" {
  name = var.domain_name
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name = var.domain_name
  zone_id     = data.aws_route53_zone.hosted_zone.zone_id

  wait_for_validation = true
}

module "service_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.env_code}-service-sg"
  vpc_id = data.terraform_remote_state.level1.outputs.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "https tp elb"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      description = "https tp elb"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = "${var.env_code}-alb"

  load_balancer_type = "application"

  vpc_id          = data.terraform_remote_state.level1.outputs.vpc_id
  subnets         = data.terraform_remote_state.level1.outputs.public_subnet_id
  security_groups = [module.service_sg.security_group_id]
  internal        = false

  target_groups = [
    {
      name_prefix      = var.env_code
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"

      health_check = {
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
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = module.acm.acm_certificate_arn
      target_group_index = 0
    }
  ]
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = keys(data.aws_route53_zone.hosted_zone)[0]

  records = [
    {
      name    = var.record_name
      type    = "CNAME"
      ttl     = 3600
      records = [module.alb.lb_dns_name]
    }
  ]
}
