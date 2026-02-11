# ========================================
# SQS Queues para Processamento de Vídeos
# ========================================

# Dead Letter Queue para cliptozip-events
resource "aws_sqs_queue" "cliptozip_events_dlq" {
  name                      = "${var.project_name}-events-dlq-${var.environment}"
  message_retention_seconds = 1209600 # 14 dias

  tags = {
    Name        = "${var.project_name}-events-dlq-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
    Type        = "DLQ"
  }
}

# Fila principal: cliptozip-events
resource "aws_sqs_queue" "cliptozip_events" {
  name                       = "${var.project_name}-events-${var.environment}"
  delay_seconds              = 0
  max_message_size           = 262144 # 256 KB
  message_retention_seconds  = 345600 # 4 dias
  receive_wait_time_seconds  = 10     # Long polling
  visibility_timeout_seconds = 300    # 5 minutos

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.cliptozip_events_dlq.arn
    maxReceiveCount     = 3
  })

  tags = {
    Name        = "${var.project_name}-events-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
    Purpose     = "Video upload notifications"
  }
}

# Dead Letter Queue para cliptozip-notifications
resource "aws_sqs_queue" "cliptozip_notifications_dlq" {
  name                      = "${var.project_name}-notifications-dlq-${var.environment}"
  message_retention_seconds = 1209600 # 14 dias

  tags = {
    Name        = "${var.project_name}-notifications-dlq-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
    Type        = "DLQ"
  }
}

# Fila principal: cliptozip-notifications
resource "aws_sqs_queue" "cliptozip_notifications" {
  name                       = "${var.project_name}-notifications-${var.environment}"
  delay_seconds              = 0
  max_message_size           = 262144 # 256 KB
  message_retention_seconds  = 345600 # 4 dias
  receive_wait_time_seconds  = 10     # Long polling
  visibility_timeout_seconds = 600    # 10 minutos (processamento pode demorar mais)

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.cliptozip_notifications_dlq.arn
    maxReceiveCount     = 3
  })

  tags = {
    Name        = "${var.project_name}-notifications-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
    Purpose     = "Video processing completion notifications"
  }
}

# ========================================
# IAM Policy para acesso às filas
# ========================================

resource "aws_sqs_queue_policy" "cliptozip_events_policy" {
  queue_url = aws_sqs_queue.cliptozip_events.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowSendMessage"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action = [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Resource = aws_sqs_queue.cliptozip_events.arn
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = var.aws_account_id
          }
        }
      }
    ]
  })
}

resource "aws_sqs_queue_policy" "cliptozip_notifications_policy" {
  queue_url = aws_sqs_queue.cliptozip_notifications.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowSendMessage"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action = [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Resource = aws_sqs_queue.cliptozip_notifications.arn
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = var.aws_account_id
          }
        }
      }
    ]
  })
}
