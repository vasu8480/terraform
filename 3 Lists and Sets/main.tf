variable "names"{
	default = ["sachin","Vasu","ravi","rohit"]
	#default = [ "Vasu","ravi","rohit"]
}
provider "aws" {
	region = "us-east-1"
}

resource "aws_iam_user" "my_iam_user_creating" {
	#count=length(var.names)       // this doesnt work properly add user before the lists and middle of the list
	#name = var.names[count.index]
	for_each = toset(var.names)
	name = each.value
}