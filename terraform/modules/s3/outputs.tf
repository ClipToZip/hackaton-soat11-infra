output "bucket_id" {
  description = "ID do bucket S3"
  value       = aws_s3_bucket.video_storage.id
}

output "bucket_arn" {
  description = "ARN do bucket S3"
  value       = aws_s3_bucket.video_storage.arn
}

output "bucket_domain_name" {
  description = "Domain name do bucket S3"
  value       = aws_s3_bucket.video_storage.bucket_domain_name
}
