variable "aws_key_pair" {
  default = "~/aws/aws_keys/aws-key-pair.pem" // to use the key pair

}

provider "aws" {
  region = "us-east-1"
}

resource "aws_default_vpc" "default" {

}

data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.default.id]
  }
}

data "aws_ami" "aws_linux_2_latest" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}

data "aws_ami_ids" "aws_linux_2_latest_ids" {
  owners = ["amazon"]
}

//security group
resource "aws_security_group" "http_server_sg" {
  name = "http_server_sg"
  //vpc_id = "vpc-f73bab8a" -- if you want to use the vpc
  vpc_id = aws_default_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "http_server_sg"
  }
}

resource "aws_instance" "http_server" {
  //ami                    = "ami-090fa75af13c156b4"
  ami                    = data.aws_ami.aws_linux_2_latest.id
  key_name               = "aws-key-pair"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.http_server_sg.id]
  //subnet_id              = "subnet-53d79335"
  subnet_id = tolist(data.aws_subnets.default_subnets.ids)[0]
  tags = {
    Name = "http_server"
  }
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.aws_key_pair) //sending key pair to the instance
  }
  provisioner "remote-exec" {
    inline = ["sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "echo 'Hello World  ${self.public_dns}' | sudo tee /var/www/html/index.html" // to write to the index.html file
    ]
  }
}
