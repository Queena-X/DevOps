data "aws_secretsmanager_secret" "database-dev" {
  name = "dev/database/password"
}

data "aws_secretsmanager_secret_version" "database-password" {
  secret_id = data.aws_secretsmanager_secret.database-dev.id
}

output "database-password" {
  value = jsondecode(data.aws_secretsmanager_secret_version.database-password.secret_string)["password"]
}
