output "cliptozip_events_queue_url" {
  description = "URL da fila cliptozip-events"
  value       = aws_sqs_queue.cliptozip_events.url
}

output "cliptozip_events_queue_arn" {
  description = "ARN da fila cliptozip-events"
  value       = aws_sqs_queue.cliptozip_events.arn
}

output "cliptozip_events_queue_name" {
  description = "Nome da fila cliptozip-events"
  value       = aws_sqs_queue.cliptozip_events.name
}

output "cliptozip_events_dlq_url" {
  description = "URL da DLQ cliptozip-events"
  value       = aws_sqs_queue.cliptozip_events_dlq.url
}

output "cliptozip_notifications_queue_url" {
  description = "URL da fila cliptozip-notifications"
  value       = aws_sqs_queue.cliptozip_notifications.url
}

output "cliptozip_notifications_queue_arn" {
  description = "ARN da fila cliptozip-notifications"
  value       = aws_sqs_queue.cliptozip_notifications.arn
}

output "cliptozip_notifications_queue_name" {
  description = "Nome da fila cliptozip-notifications"
  value       = aws_sqs_queue.cliptozip_notifications.name
}

output "cliptozip_notifications_dlq_url" {
  description = "URL da DLQ cliptozip-notifications"
  value       = aws_sqs_queue.cliptozip_notifications_dlq.url
}
