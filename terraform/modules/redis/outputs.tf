output "cluster_id" {
  description = "ID do cluster Redis"
  value       = aws_elasticache_cluster.redis.id
}

output "cluster_address" {
  description = "Endereço do cluster Redis"
  value       = aws_elasticache_cluster.redis.cache_nodes[0].address
}

output "cluster_port" {
  description = "Porta do cluster Redis"
  value       = aws_elasticache_cluster.redis.cache_nodes[0].port
}

output "cluster_arn" {
  description = "ARN do cluster Redis"
  value       = aws_elasticache_cluster.redis.arn
}
