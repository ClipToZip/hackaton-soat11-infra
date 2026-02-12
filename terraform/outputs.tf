# ========================================
# Networking Outputs
# ========================================

output "vpc_id" {
  description = "ID da VPC"
  value       = module.networking.vpc_id
}

output "public_subnet_ids" {
  description = "IDs das subnets públicas"
  value       = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs das subnets privadas"
  value       = module.networking.private_subnet_ids
}

# ========================================
# S3 Outputs
# ========================================

output "s3_bucket_name" {
  description = "Nome do bucket S3"
  value       = module.s3.bucket_id
}

output "s3_bucket_arn" {
  description = "ARN do bucket S3"
  value       = module.s3.bucket_arn
}

# ========================================
# RDS Outputs
# ========================================

output "rds_endpoint" {
  description = "Endpoint do RDS PostgreSQL"
  value       = module.rds.db_endpoint
}

output "rds_address" {
  description = "Endereço do RDS PostgreSQL"
  value       = module.rds.db_address
}

output "rds_port" {
  description = "Porta do RDS PostgreSQL"
  value       = module.rds.db_port
}

output "rds_database_name" {
  description = "Nome do database do RDS"
  value       = module.rds.db_name
}

# ========================================
# Redis Outputs
# ========================================

output "redis_endpoint" {
  description = "Endpoint do Redis Serverless"
  value       = module.redis.cache_endpoint
}

output "redis_port" {
  description = "Porta do Redis Serverless"
  value       = module.redis.cache_port
}

# ========================================
# SQS Outputs
# ========================================

output "cliptozip_events_queue_url" {
  description = "URL da fila cliptozip-events"
  value       = module.sqs.cliptozip_events_queue_url
}

output "cliptozip_events_queue_name" {
  description = "Nome da fila cliptozip-events"
  value       = module.sqs.cliptozip_events_queue_name
}

output "cliptozip_notifications_queue_url" {
  description = "URL da fila cliptozip-notifications"
  value       = module.sqs.cliptozip_notifications_queue_url
}

output "cliptozip_notifications_queue_name" {
  description = "Nome da fila cliptozip-notifications"
  value       = module.sqs.cliptozip_notifications_queue_name
}

# ========================================
# Connection Info (Consolidated)
# ========================================

output "connection_info" {
  description = "Informações de conexão consolidadas"
  value = {
    s3_bucket = module.s3.bucket_id
    postgres = {
      host     = module.rds.db_address
      port     = module.rds.db_port
      database = module.rds.db_name
      username = var.db_username
    }
    redis = {
      host = module.redis.cache_endpoint
      port = module.redis.cache_port
    }
    sqs = {
      cliptozip_events_url      = module.sqs.cliptozip_events_queue_url
      cliptozip_events_name     = module.sqs.cliptozip_events_queue_name
      cliptozip_notifications_url  = module.sqs.cliptozip_notifications_queue_url
      cliptozip_notifications_name = module.sqs.cliptozip_notifications_queue_name
    }
  }
  sensitive = false
}
