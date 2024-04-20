
provider "aws" {
  region = "us-east-1"
}


  locals {
  relative_path_to_external_directory = "dataset"
#   dataset_path = "${path.root}/${local.relative_path_to_external_directory}"
  dataset_path = replace(path.cwd,"terraforms","dataset")
}



output "new_path_output" {
  value = local.dataset_path
}


#Creating s3 bucket to upload the student image in a s3 bucket.
resource "aws_s3_bucket" "new-student-registration-tf" {
  bucket = "new-student-registration-tf"
  force_destroy = true

  tags = {
    Name        = "new-student-registration-tf"
    Environment = "Dev"
  }
}

#Creating bucket for student attendace authentication
resource "aws_s3_bucket" "class-images-tf" {
  bucket = "class-images-tf"
   force_destroy = true

  tags = {
    Name        = "class-images-tf"
    Environment = "Dev"
  }
}


# resource "aws_s3_object" "upload-dataset-files-bucket" {
#   bucket = aws_s3_bucket.swen614-dataset.id
#   for_each = fileset(local.dataset_path,"*")
#   key    = each.value
#   source = "${local.dataset_path}/${each.value}"

#   # The filemd5() function is available in Terraform 0.11.12 and later
#   # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
#   etag = filemd5("${local.dataset_path}/${each.value}")
# #   
# }