variable "names"{
	default = [ "Vasu","ravi","rohit"]
}
provider "aws" {
	region = "us-east-1"
}

resource "aws_iam_user" "my_iam_user_creating" {
	count=length(var.names)
	name = var.names[count.index]
}