output "db_instance_id" {
  description = "ID da instância RDS"
  value       = aws_db_instance.postgres.id
}

output "db_endpoint" {
  description = "Endpoint do RDS"
  value       = aws_db_instance.postgres.endpoint
}

output "db_address" {
  description = "Endereço do RDS"
  value       = aws_db_instance.postgres.address
}

output "db_port" {
  description = "Porta do RDS"
  value       = aws_db_instance.postgres.port
}

output "db_name" {
  description = "Nome do database"
  value       = aws_db_instance.postgres.db_name
}

output "db_arn" {
  description = "ARN da instância RDS"
  value       = aws_db_instance.postgres.arn
}
