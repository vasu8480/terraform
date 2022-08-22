variable "aws_key_pair" {
  default = "~/aws/aws_keys/aws-key-pair.pem" // to use the key pair

}

provider "aws" {
  region = "us-east-1"
}

//security group
resource "aws_security_group" "http_server_sg" {
  name = "http_server_sg"
  //vpc_id = "vpc-c49ff1be"
  vpc_id = "vpc-f73bab8a"

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
  ami                    = "ami-090fa75af13c156b4"
  key_name               = "aws-key-pair"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.http_server_sg.id]
  subnet_id              = "subnet-53d79335"
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
