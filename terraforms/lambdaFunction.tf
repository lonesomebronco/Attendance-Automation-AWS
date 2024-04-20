locals {
  python_files = replace(path.cwd,"terraforms","Lambda_Functions")
}

data "archive_file" "zip_the_student_registration_code" {
  type        = "zip"
  source_dir  = "${local.python_files}/Function-1/"
  output_path = "${local.python_files}/Function-1/student_registration_tf.zip" 
}

data "archive_file" "zip_the_student_authentication_code" {
  type        = "zip"
  source_dir  = "${local.python_files}/Function-2/"
  output_path = "${local.python_files}/Function-2/student_authentication_tf.zip" 
}

resource "aws_lambda_function" "terraform_lambda_func" {
  filename      = data.archive_file.zip_the_student_registration_code.output_path
  function_name = "student_registration_tf"
  role          = aws_iam_role.role_for_lamda_functions_tf.arn
  handler       = "student_registration_tf.lambda_handler"
  runtime       = "python3.8"
  memory_size   = 500
  timeout       = 50
}

resource "aws_lambda_function" "terraform_lambda_func_authentication" {
  filename      = data.archive_file.zip_the_student_authentication_code.output_path
  function_name = "student_authentication_tf"
  role          = aws_iam_role.role_for_lamda_functions_tf.arn
  handler       = "student_authentication_tf.lambda_handler"
  runtime       = "python3.8"
  memory_size   = 500
  timeout       = 50
}



resource "aws_lambda_permission" "s3_invoke_permission" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.terraform_lambda_func.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.new-student-registration-tf.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.new-student-registration-tf.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.terraform_lambda_func.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = ""
    filter_suffix       = ""
  }
}