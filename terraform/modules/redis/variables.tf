variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
}

variable "subnet_ids" {
  description = "IDs das subnets para o Redis subnet group"
  type        = list(string)
}

variable "security_group_ids" {
  description = "IDs dos security groups"
  type        = list(string)
}

variable "major_engine_version" {
  description = "Versão major do Redis (ex: 7)"
  type        = string
  default     = "7"
}

variable "max_data_storage_gb" {
  description = "Armazenamento máximo de dados em GB para o cache serverless"
  type        = number
  default     = 5
}

variable "max_ecpu_per_second" {
  description = "ECPU máximo por segundo para o cache serverless"
  type        = number
  default     = 5000
}

variable "daily_snapshot_time" {
  description = "Horário diário para snapshot automático (formato: HH:MM)"
  type        = string
  default     = "03:00"
}

variable "snapshot_retention_limit" {
  description = "Número de dias para reter snapshots automáticos"
  type        = number
  default     = 1
}
