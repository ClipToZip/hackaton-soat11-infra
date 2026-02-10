# ========================================
# S3 Bucket para Armazenamento de Vídeos
# ========================================

resource "aws_s3_bucket" "video_storage" {
  bucket = "${var.project_name}-videos-${var.environment}"

  tags = {
    Name        = "${var.project_name}-videos-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_s3_bucket_versioning" "video_storage" {
  bucket = aws_s3_bucket.video_storage.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "video_storage" {
  bucket = aws_s3_bucket.video_storage.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
