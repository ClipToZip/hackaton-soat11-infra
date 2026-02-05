output "video_event_queue_url" {
  description = "URL da fila video-event"
  value       = aws_sqs_queue.video_event.url
}

output "video_event_queue_arn" {
  description = "ARN da fila video-event"
  value       = aws_sqs_queue.video_event.arn
}

output "video_event_queue_name" {
  description = "Nome da fila video-event"
  value       = aws_sqs_queue.video_event.name
}

output "video_event_dlq_url" {
  description = "URL da DLQ video-event"
  value       = aws_sqs_queue.video_event_dlq.url
}

output "video_processed_queue_url" {
  description = "URL da fila video-processed"
  value       = aws_sqs_queue.video_processed.url
}

output "video_processed_queue_arn" {
  description = "ARN da fila video-processed"
  value       = aws_sqs_queue.video_processed.arn
}

output "video_processed_queue_name" {
  description = "Nome da fila video-processed"
  value       = aws_sqs_queue.video_processed.name
}

output "video_processed_dlq_url" {
  description = "URL da DLQ video-processed"
  value       = aws_sqs_queue.video_processed_dlq.url
}
