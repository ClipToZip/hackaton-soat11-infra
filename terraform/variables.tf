variable "region_default" {
  description = "Região da AWS onde a infraestrutura será provisionada"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
  default     = "cliptozip"
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block para a VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Zonas de disponibilidade"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

# RDS Variables
variable "db_name" {
  description = "Nome do banco de dados"
  type        = string
  default     = "videodb"
}

variable "db_username" {
  description = "Username do banco de dados"
  type        = string
  default     = "dbadmin"
}

variable "db_password" {
  description = "Senha do banco de dados"
  type        = string
  sensitive   = true
  default     = "ChangeMe123!"
}

variable "db_instance_class" {
  description = "Classe da instância do RDS"
  type        = string
  default     = "db.t4g.micro"
}

# Seu IP público para acesso remoto
variable "my_ip" {
  description = "Seu IP público para acesso aos recursos (formato: x.x.x.x/32)"
  type        = string
  default     = "0.0.0.0/0" # ATENÇÃO: Trocar pelo seu IP real para segurança
}