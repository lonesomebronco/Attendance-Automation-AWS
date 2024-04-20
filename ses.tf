# IAM role for Lambda function to access DynamoDB and SES
resource "aws_iam_role" "lambda_email_notification_role" {
  name               = "lambda_email_notification_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Policy allowing access to DynamoDB and SES
resource "aws_iam_policy" "lambda_dynamodb_ses_access" {
  name        = "lambda_dynamodb_ses_access"
  description = "Allow Lambda to access DynamoDB and SES"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:GetItem",
          "dynamodb:Scan",
          "dynamodb:Query"
        ],
        Resource = aws_dynamodb_table.attendance_records_tf.arn
      },
      {
        Effect = "Allow",
        Action = [
          "ses:SendEmail",
          "ses:SendRawEmail"
        ],
        Resource = "*"
      }
    ]
  })
}

# Attach policy to IAM role
resource "aws_iam_role_policy_attachment" "lambda_dynamodb_ses_attachment" {
  role       = aws_iam_role.lambda_email_notification_role.name
  policy_arn = aws_iam_policy.lambda_dynamodb_ses_access.arn
}

# Lambda function to process attendance data and send emails
resource "aws_lambda_function" "attendance_email_notifier" {
  function_name = "attendance_email_notifier"
  role          = aws_iam_role.lambda_email_notification_role.arn
  handler       = "handler.handler"
  runtime       = "python3.8"
  
  # Assuming code is packaged and uploaded to S3
  s3_bucket = "your-lambda-code-bucket"
  s3_key    = "attendance_email_notifier.zip"

  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.attendance_records_tf.name,
      SES_REGION     = "us-east-1"
    }
  }
}

# Trigger Lambda function on a schedule using EventBridge
resource "aws_cloudwatch_event_rule" "daily_attendance_check" {
  name                = "daily_attendance_check"
  schedule_expression = "cron(0 20 * * ? *)"  # Runs daily at 8 PM UTC
}

resource "aws_cloudwatch_event_target" "invoke_lambda_daily" {
  rule      = aws_cloudwatch_event_rule.daily_attendance_check.name
  target_id = "LambdaTarget"
  arn       = aws_lambda_function.attendance_email_notifier.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.attendance_email_notifier.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_attendance_check.arn
}
