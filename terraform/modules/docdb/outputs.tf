output "docdb_endpoint" {
  value = aws_docdb_cluster.default.endpoint
}

output "docdb_credentials" {
  value     = jsondecode(data.aws_secretsmanager_secret_version.docdb_credentials.secret_string)
  sensitive = true
}