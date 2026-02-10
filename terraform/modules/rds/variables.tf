variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
}

variable "subnet_ids" {
  description = "IDs das subnets para o DB subnet group"
  type        = list(string)
}

variable "security_group_ids" {
  description = "IDs dos security groups"
  type        = list(string)
}

variable "instance_class" {
  description = "Classe da instância do RDS"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Tamanho do storage em GB"
  type        = number
  default     = 20
}

variable "db_name" {
  description = "Nome do banco de dados"
  type        = string
}

variable "db_username" {
  description = "Username do banco de dados"
  type        = string
}

variable "db_password" {
  description = "Senha do banco de dados"
  type        = string
  sensitive   = true
}

variable "publicly_accessible" {
  description = "Se o banco deve ser publicly accessible"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Se deve pular o snapshot final ao destruir"
  type        = bool
  default     = true
}

variable "backup_retention_period" {
  description = "Período de retenção de backups em dias"
  type        = number
  default     = 7
}

variable "multi_az" {
  description = "Se deve habilitar Multi-AZ"
  type        = bool
  default     = false
}
