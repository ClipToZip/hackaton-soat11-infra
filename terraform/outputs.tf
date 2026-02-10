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
  description = "Endpoint do Redis"
  value       = module.redis.cluster_address
}

output "redis_port" {
  description = "Porta do Redis"
  value       = module.redis.cluster_port
}

# ========================================
# SQS Outputs
# ========================================

output "video_event_queue_url" {
  description = "URL da fila video-event"
  value       = module.sqs.video_event_queue_url
}

output "video_event_queue_name" {
  description = "Nome da fila video-event"
  value       = module.sqs.video_event_queue_name
}

output "video_processed_queue_url" {
  description = "URL da fila video-processed"
  value       = module.sqs.video_processed_queue_url
}

output "video_processed_queue_name" {
  description = "Nome da fila video-processed"
  value       = module.sqs.video_processed_queue_name
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
      host = module.redis.cluster_address
      port = module.redis.cluster_port
    }
    sqs = {
      video_event_url      = module.sqs.video_event_queue_url
      video_event_name     = module.sqs.video_event_queue_name
      video_processed_url  = module.sqs.video_processed_queue_url
      video_processed_name = module.sqs.video_processed_queue_name
    }
  }
  sensitive = false
}
