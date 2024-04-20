
#Creating an IAM role for Lambda Use case
resource "aws_iam_role" "role_for_lamda_functions_tf" {
name               = "lambda_execution_role"
assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "swen614_cloudwatch_policy" {
  name        = "cloudwatch_policy"
  description = "Allows logging to CloudWatch Logs"
   policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "logs:*",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "swen614_s3_policy" {
  name        = "s3_policy"
  description = "Allows access to S3 buckets"
 policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "swen614_dynamodb_policy" {
  name        = "dynamodb_policy"
  description = "Allows access to DynamoDB tables"
   policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "dynamodb:*",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "swen614_rekognition_policy" {
  name        = "rekognition_policy"
  description = "Allows access to Rekognition service"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "rekognition:*",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "swen614_cloudwatch_attach" {
  role       = aws_iam_role.role_for_lamda_functions_tf.name
  policy_arn = aws_iam_policy.swen614_cloudwatch_policy.arn
}

resource "aws_iam_role_policy_attachment" "s3_attach" {
  role       = aws_iam_role.role_for_lamda_functions_tf.name
  policy_arn = aws_iam_policy.swen614_s3_policy.arn
}

resource "aws_iam_role_policy_attachment" "dynamodb_attach" {
  role       = aws_iam_role.role_for_lamda_functions_tf.name
  policy_arn = aws_iam_policy.swen614_dynamodb_policy.arn
}

resource "aws_iam_role_policy_attachment" "rekognition_attach" {
  role       = aws_iam_role.role_for_lamda_functions_tf.name
  policy_arn = aws_iam_policy.swen614_rekognition_policy.arn
}


# #Attaching AWS lambda full access to the IAM role
# resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
#   role        = aws_iam_role.swen614-lambda-role.name
#   policy_arn  = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
# }



# IAM role for API Gateway for API to add image in new_student_registration_tf
resource "aws_iam_role" "role_for_api_gateway_registration" {
  name = "role_for_api_gateway_registration"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Attach AmazonAPIGatewayPushToCloudWatchLogs policy
resource "aws_iam_policy_attachment" "api_gateway_registration_cloudwatch_logs" {
  name       = "AmazonAPIGatewayPushToCloudWatchLogs"
  roles      = [aws_iam_role.role_for_api_gateway_registration.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

# Inline policy for PutObject action on 'new_student_registration_tf' S3 bucket
resource "aws_iam_role_policy" "s3_putobject_policy_reg" {
#   name   = "s3_putobject_policy_reg"
  role   = aws_iam_role.role_for_api_gateway_registration.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "s3:PutObject"
        Resource = "arn:aws:s3:::new-student-registration-tf/*"
      }
    ]
  })
}

# IAM Role for API Gateway for API to add image in class_images_tf
resource "aws_iam_role" "role_for_api_gateway_authentication" {
  name = "role_for_api_gateway_authentication"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Attach AmazonAPIGatewayPushToCloudWatchLogs policy
resource "aws_iam_policy_attachment" "api_gateway_cloudwatch_logs" {
  name       = "AmazonAPIGatewayPushToCloudWatchLogs"
  roles      = [aws_iam_role.role_for_api_gateway_authentication.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

# Inline policy for PutObject action on 'class_images_tf' S3 bucket
resource "aws_iam_role_policy" "s3_putobject_policy" {
  name   = "s3_putobject_policy"
  role   = aws_iam_role.role_for_api_gateway_authentication.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "s3:PutObject"
        Resource = "arn:aws:s3:::class-images-tf/*"
      }
    ]
  })
}