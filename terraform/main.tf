# ========================================
# Networking Module
# ========================================

module "networking" {
  source = "./modules/networking"

  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
}

# ========================================
# Security Groups Module
# ========================================

module "security_groups" {
  source = "./modules/security-groups"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.networking.vpc_id
  vpc_cidr     = module.networking.vpc_cidr
  my_ip        = var.my_ip

  depends_on = [module.networking]
}

# ========================================
# S3 Module
# ========================================

module "s3" {
  source = "./modules/s3"

  project_name = var.project_name
  environment  = var.environment
}

# ========================================
# RDS Module
# ========================================

module "rds" {
  source = "./modules/rds"

  project_name            = var.project_name
  environment             = var.environment
  subnet_ids              = module.networking.public_subnet_ids
  security_group_ids      = [module.security_groups.rds_security_group_id]
  instance_class          = var.db_instance_class
  allocated_storage       = 20
  db_name                 = var.db_name
  db_username             = var.db_username
  db_password             = var.db_password
  publicly_accessible     = true # Para testes locais
  skip_final_snapshot     = true
  backup_retention_period = 7
  multi_az                = false

  depends_on = [module.networking, module.security_groups]
}

# ========================================
# Redis Module
# ========================================

module "redis" {
  source = "./modules/redis"

  project_name       = var.project_name
  environment        = var.environment
  subnet_ids         = module.networking.public_subnet_ids
  security_group_ids = [module.security_groups.redis_security_group_id]

  depends_on = [module.networking, module.security_groups]
}

# ========================================
# SQS Module
# ========================================

module "sqs" {
  source = "./modules/sqs"

  project_name   = var.project_name
  environment    = var.environment
  aws_account_id = data.aws_caller_identity.current.account_id
}

# ========================================
# Data Sources
# ========================================

data "aws_caller_identity" "current" {}