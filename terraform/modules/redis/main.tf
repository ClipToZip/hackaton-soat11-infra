# ========================================
# ElastiCache Redis Serverless
# ========================================

resource "aws_elasticache_serverless_cache" "redis" {
  name   = "${var.project_name}-redis-${var.environment}"
  engine = "redis"

  cache_usage_limits {
    data_storage {
      maximum = var.max_data_storage_gb
      unit    = "GB"
    }
    ecpu_per_second {
      maximum = var.max_ecpu_per_second
    }
  }

  daily_snapshot_time      = var.daily_snapshot_time
  description             = "Redis Serverless for ${var.project_name} - ${var.environment}"
  major_engine_version    = var.major_engine_version
  snapshot_retention_limit = var.snapshot_retention_limit
  security_group_ids      = var.security_group_ids
  subnet_ids              = var.subnet_ids

  tags = {
    Name        = "${var.project_name}-redis-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
  }
}
