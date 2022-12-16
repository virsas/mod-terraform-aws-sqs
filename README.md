# mod-terraform-aws-sqs

Terraform module to create S3 bucket

## Variables

- **profile** - The profile from ~/.aws/credentials file used for authentication. By default it is the default profile.
- **accountID** - ID of your AWS account. It is a required variable normally used in JSON files or while assuming a role.
- **region** - The region for the resources. By default it is eu-west-1.
- **assumeRole** - Enable / Disable role assume. This is disabled by default and normally used for sub organization configuration.
- **assumableRole** - The role the user will assume if assumeRole is enabled. By default, it is OrganizationAccountAccessRole.
- **name** - Name of the SQS queue. If FIFO is enabled, it will by named name.fifo automatically. If deadletter is enabled, the queue for the deadletters will be named name_deadletter.
- **fifo** - Enable / Disable FIFO mode. Defaults to true. If disabled, the queue is in standard mode.
- **sse_enabled** - Enable server-side encryption (SSE) of message content with SQS-owned encryption keys. Defaults to true.
- **kms** - ARN of KMS key, if kms should be encrypted with own key. By default, this value is null. This requires sse_enabled to be set to false.
- **kms_reuse_in_seconds** - Time, in seconds, for which Amazon SQS can reuse a data key to encrypt or decrypt messages before calling AWS KMS again. Defaults to 300
- **message_retention_seconds** - The number of seconds Amazon SQS retains a message. From 60 (1 minute) to 1209600 (14 days). Defaults to 4 days - 345600 seconds
- **visibility_timeout_seconds** - The timeout for consumed message not to be visible to other consumers. From 0 to 43200 seconds. Defaults to 30.
- **max_message_size** - The limit of how many bytes a message can contain before Amazon SQS rejects it. From 1024 bytes (1 KiB) up to 262144 bytes (256 KiB). Defaults to 262144 (256 KiB)
- **delay_seconds** - The time before the message is available to consumers after being delivered to the queue. From 0 to 900 seconds. Defaults to 0
- **receive_wait_time_seconds** - Wait time for a ReceiveMessage call. From 0 to 20 seconds. Defaults to 0.
- **deadletter_enabled** - Enable / Disable deadletter queue. Queue with messages that were received by consumere, but never deleted. Defaults to true.
- **deadletter_message_retention_seconds** - The number of seconds Deadletter queue will retain a message from 60 to 1209600 secconds. Defaults to 1209600 (14 days).
- **deadletter_failures_count** - The number of times a consumer tries receiving a message from a queue without deleting it before being moved to the dead-letter queue. Defaults to 3
- **policy_enabled** - Enable/Disable access policy for this queue.
- **policy_path** - Path to directory with all the policies. By default ./json/sqs/NAME.json where the name is the name of the bucket

## Example

``` terraform
variable accountID { default = "123456789012"}

module "sqs_example" {
  source   = "git::https://github.com/virsas/mod-terraform-aws-sqs.git?ref=v1.0.0"

  profile = "default"
  accountID = var.accountID
  region = "eu-west-1"

  name = "example"
}
```

## Outputs

- id
- arn
- url