output "username" {
  value = "database-dev"
}

output "database-password" {
  value = jsondecode(data.aws_secretsmanager_secret_version.database-password.secret_string)["password"]
}
