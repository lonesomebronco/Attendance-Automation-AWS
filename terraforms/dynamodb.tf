resource "aws_dynamodb_table" "class_student_tf" {
  name           = "class_student_tf"
  billing_mode   = "PAY_PER_REQUEST" 
  hash_key       = "rekognitionId" 
  attribute {
    name = "rekognitionId"
    type = "S" 
  }
}

resource "aws_dynamodb_table" "attendance_records_tf" {
  name           = "attendance_records_tf"
  billing_mode   = "PAY_PER_REQUEST" 
  hash_key       = "date" 
  
  attribute {
    name = "date"
    type = "S" // String type for the primary key attribute
  }
}
