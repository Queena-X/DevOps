module "rds_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.env_code}-rds-sg"
  vpc_id = data.terraform_remote_state.level1.outputs.vpc_id

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
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

module "rds" {
  source = "terraform-aws-modules/rds/aws"

  identifier = var.env_code

  engine            = "mysql"
  engine_version    = "5.7"
  instance_class    = "db.t3a.large"
  allocated_storage = 5

  db_name  = var.dbname
  username = var.username
  password = local.rds_password
  port     = "3306"

  skip_final_snapshot = true
  multi_az            = false

  vpc_security_group_ids = data.terraform_remote_state.level1.outputs

  backup_retention_period = 0
  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"

  family               = "mysql5.7"
  major_engine_version = "5.7"
}
