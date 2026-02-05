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

variable "node_type" {
  description = "Tipo de nó do Redis"
  type        = string
  default     = "cache.t3.micro"
}

variable "num_cache_nodes" {
  description = "Número de nós do cache"
  type        = number
  default     = 1
}

variable "parameter_group_name" {
  description = "Nome do parameter group"
  type        = string
  default     = "default.redis7"
}

variable "engine_version" {
  description = "Versão do Redis"
  type        = string
  default     = "7.0"
}

variable "port" {
  description = "Porta do Redis"
  type        = number
  default     = 6379
}
