output "cache_name" {
  description = "Nome do cache Redis Serverless"
  value       = aws_elasticache_serverless_cache.redis.name
}

output "cache_arn" {
  description = "ARN do cache Redis Serverless"
  value       = aws_elasticache_serverless_cache.redis.arn
}

output "cache_endpoint" {
  description = "Endpoint do cache Redis Serverless (para leitura/escrita)"
  value       = aws_elasticache_serverless_cache.redis.endpoint[0].address
}

output "cache_port" {
  description = "Porta do cache Redis Serverless"
  value       = aws_elasticache_serverless_cache.redis.endpoint[0].port
}

output "reader_endpoint" {
  description = "Reader endpoint do cache Redis Serverless"
  value       = aws_elasticache_serverless_cache.redis.reader_endpoint[0].address
}
