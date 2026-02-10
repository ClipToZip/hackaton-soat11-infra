terraform {
  backend "s3" {
    bucket         = "hackaton-soat11-cliptozip-tfstate"
    key            = "infra/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "hackaton-soat11-cliptozip-terraform-locks"
  }
}