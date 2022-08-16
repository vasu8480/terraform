variable "users" {
  # default = {
  # 						sachin:"india",
  # 						Vasu:"Ap",
  # 						ravi:"kakinada",
  # 						rohit:"mumbai"
  # 					}
  default = {
    sachin : { country : "india", departement : "abc" },
    Vasu : { country : "Ap", departement : "xyz" },
    ravi : { country : "kakinada ", departement : "pqr" }
  }
}
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "my_iam_user_creating" {
  for_each = var.users
  name     = each.key
  # tags={
  # 	country:each.value
  # }
  tags = {
    country : each.value.country
    departement : each.value.departement
  }
}