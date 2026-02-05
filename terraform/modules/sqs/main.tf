# ========================================
# SQS Queues para Processamento de Vídeos
# ========================================

# Dead Letter Queue para video-event
resource "aws_sqs_queue" "video_event_dlq" {
  name                      = "${var.project_name}-video-event-dlq-${var.environment}"
  message_retention_seconds = 1209600 # 14 dias

  tags = {
    Name        = "${var.project_name}-video-event-dlq-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
    Type        = "DLQ"
  }
}

# Fila principal: video-event
resource "aws_sqs_queue" "video_event" {
  name                       = "${var.project_name}-video-event-${var.environment}"
  delay_seconds              = 0
  max_message_size           = 262144 # 256 KB
  message_retention_seconds  = 345600 # 4 dias
  receive_wait_time_seconds  = 10     # Long polling
  visibility_timeout_seconds = 300    # 5 minutos

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.video_event_dlq.arn
    maxReceiveCount     = 3
  })

  tags = {
    Name        = "${var.project_name}-video-event-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
    Purpose     = "Video upload notifications"
  }
}

# Dead Letter Queue para video-processed
resource "aws_sqs_queue" "video_processed_dlq" {
  name                      = "${var.project_name}-video-processed-dlq-${var.environment}"
  message_retention_seconds = 1209600 # 14 dias

  tags = {
    Name        = "${var.project_name}-video-processed-dlq-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
    Type        = "DLQ"
  }
}

# Fila principal: video-processed
resource "aws_sqs_queue" "video_processed" {
  name                       = "${var.project_name}-video-processed-${var.environment}"
  delay_seconds              = 0
  max_message_size           = 262144 # 256 KB
  message_retention_seconds  = 345600 # 4 dias
  receive_wait_time_seconds  = 10     # Long polling
  visibility_timeout_seconds = 600    # 10 minutos (processamento pode demorar mais)

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.video_processed_dlq.arn
    maxReceiveCount     = 3
  })

  tags = {
    Name        = "${var.project_name}-video-processed-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
    Purpose     = "Video processing completion notifications"
  }
}

# ========================================
# IAM Policy para acesso às filas
# ========================================

resource "aws_sqs_queue_policy" "video_event_policy" {
  queue_url = aws_sqs_queue.video_event.id

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
        Resource = aws_sqs_queue.video_event.arn
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = var.aws_account_id
          }
        }
      }
    ]
  })
}

resource "aws_sqs_queue_policy" "video_processed_policy" {
  queue_url = aws_sqs_queue.video_processed.id

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
        Resource = aws_sqs_queue.video_processed.arn
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = var.aws_account_id
          }
        }
      }
    ]
  })
}
