provider "aws" {
	region = "us-east-1"
}

resource "aws_s3_bucket" "vasu8" {
	bucket = "my-vasu8480" //can't change the bucket name
	# versioning {
  #   enabled = true				//method-1 versioning is enabled 
  # }
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.vasu8.id
  versioning_configuration {
    status = "Enabled"		// method2 versioning is enabled
  }
}

resource "aws_iam_user" "creating_user_for_vasu" {
	name = "terraform_user_vasu"		// can able to upadte the user name
}