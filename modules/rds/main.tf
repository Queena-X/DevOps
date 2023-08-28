resource "awscc_rds_db_subnet_group" "rds-sg" {
  db_subnet_group_description = "rds-sg"
  subnet_ids                  = [var.subnet_ids]

  tags = {
    Name = var.env_code
  }
}

resource "aws_security_group" "rds-secg" {
  name   = "${var.env_code}-rds"
  vpc_id = var.vpc_id

  ingress {
    from_port       = "3306"
    to_port         = "3306"
    protocol        = "tcp"
    security_groups = [var.source_secg]
  }

  tags = {
    Name = var.env_code
  }
}

resource "aws_db_instance" "database-postgres-dev" {
  identifier              = var.env_code
  allocated_storage       = 10
  max_allocated_storage   = 100
  db_name                 = "database-mysql-dev"
  engine                  = "mysql"
  engine_version          = "5.7"
  instance_class          = "db.t3.micro"
  username                = var.username
  password                = var.rds_password
  parameter_group_name    = "default.mysql5.7"
  db_subnet_group_name    = aws_security_group.rds-secg
  skip_final_snapshot     = true
  multi_az                = true
  backup_retention_period = 35
  backup_window           = "22:00-23:00"
}
