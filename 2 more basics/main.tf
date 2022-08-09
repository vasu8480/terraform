provider "aws" {
	region = "us-east-1"
}

resource "aws_iam_user" "creating_users" {
	count=3	// if count increses, then the extra user will be created
	name = "terraform_user_vasu${count.index}"		
}