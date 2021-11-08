provider "aws" {
  region = "us-east-1"
}


resource "aws_instance" "my" {
  ami           = "ami-09e67e426f25ce0d7"
  instance_type = "t3.micro"

  tags = {
    Name    = "My Server"
    Project = "My Project"
  }
}
