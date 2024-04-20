# # Verify an email address in AWS SES
# resource "aws_ses_email_identity" "email_identity" {
#   email = "naikpraneet44@gmail.com"
# }

# # IAM role for Lambda function
# resource "aws_iam_role" "lambda_role_for_ses" {
#   name = "lambda_role_for_ses"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "lambda.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# # IAM policy to allow Lambda function to send SES emails
# resource "aws_iam_policy" "lambda_policy_for_ses" {
#   name        = "lambda_policy_for_ses"
#   description = "IAM policy for Lambda to send emails via SES"

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action   = [
#           "ses:SendEmail",
#           "ses:SendRawEmail"
#         ]
#         Effect   = "Allow"
#         Resource = "*"
#       }
#     ]
#   })
# }

# # Attach the policy to the role
# resource "aws_iam_role_policy_attachment" "lambda_policy_attachment_for_ses" {
#   role       = aws_iam_role.lambda_role_for_ses.name
#   policy_arn = aws_iam_policy.lambda_policy_for_ses.arn
# }

# # Lambda function to send emails
# resource "aws_lambda_function" "send_email_lambda" {
#   filename         = "Lambda_Functions/Function-1/student_registration_tf.zip"
#   function_name    = "send_email"
#   role             = aws_iam_role.lambda_role_for_ses.arn
#   handler          = "lambda_function.lambda_handler"
#   runtime          = "python3.8"
#   source_code_hash = filebase64sha256("path/to/your/lambda_function.zip")
# }

# # Permission for SES to trigger Lambda function
# resource "aws_lambda_permission" "allow_ses_invoke" {
#   statement_id  = "AllowExecutionFromSES"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.send_email_lambda.function_name
#   principal     = "ses.amazonaws.com"
#   source_arn    = aws_ses_email_identity.email_identity.arn
# }

# output "lambda_function_name" {
#   value = aws_lambda_function.send_email_lambda.function_name
# }

# output "verified_email" {
#   value = aws_ses_email_identity.email_identity.email
# }
