output "rds_security_group_id" {
  description = "ID do security group do RDS"
  value       = aws_security_group.rds.id
}

output "redis_security_group_id" {
  description = "ID do security group do Redis"
  value       = aws_security_group.redis.id
}
