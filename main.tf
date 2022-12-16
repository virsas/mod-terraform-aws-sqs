provider "aws" {
  profile = var.profile
  region = var.region

  assume_role {
    role_arn = var.assumeRole ? "arn:aws:iam::${var.accountID}:role/${var.assumableRole}" : null
  }
}

resource "aws_sqs_queue" "vss_deadletter" {
  count = var.deadletter_enabled ? 1 : 0

  name                       = var.fifo ? "${var.name}_deadletter.fifo" : "${var.name}_deadletter"
  fifo_queue                 = var.fifo

  sqs_managed_sse_enabled           = var.sse_enablad ? true : null
  kms_master_key_id                 = var.sse_enabled ? null : try(var.kms, null)
  kms_data_key_reuse_period_seconds = var.kms_reuse_in_seconds

  message_retention_seconds  = var.deadletter_message_retention_seconds
}

resource "aws_sqs_queue" "vss" {
  name                       = var.fifo ? "${var.name}.fifo" : var.name
  fifo_queue                 = var.fifo

  sqs_managed_sse_enabled           = var.sse_enablad ? true : null
  kms_master_key_id                 = var.sse_enabled ? null : try(var.kms, null)
  kms_data_key_reuse_period_seconds = var.kms_reuse_in_seconds

  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  max_message_size           = var.max_message_size
  delay_seconds              = var.delay_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  redrive_policy = var.deadletter_enabled ? jsonencode({ deadLetterTargetArn = aws_sqs_queue.vss_deadletter.arn, maxReceiveCount = var.deadletter_failures_count })
}

data "template_file" "vss" {
  count = var.policy_enabled ? 1 : 0

  template = file("${var.policy_path}/${var.name}.json")
}

resource "aws_sqs_queue_policy" "policy" {
  count = var.policy_enabled ? 1 : 0

  queue_url = aws_sqs_queue.vss.arn
  policy = data.template_file.vss.rendered

  depends_on = [aws_sqs_queue.vss]
}