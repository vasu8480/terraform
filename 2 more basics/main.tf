variable "iam_user_name_prefix" {
  type    = string #any, number, bool, list, map, set, object, tuple
  default = "my_iam_user"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "my_iam_users" {
  count = 1
  name  = "${var.iam_user_name_prefix}_${count.index}"
}

// you can pass the value from command line to the variable or tfvars
// terraform apply -refresh=flase -var="iam_user_name_prefix=value from command line"