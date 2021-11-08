provider "aws" {
  region = "us-east-1"
}

resource "aws_eip" "my_static_ip" {
  instance = aws_instance.webserver.id
}

resource "aws_instance" "webserver" {
  ami                    = "ami-0c2b8ca1dad447f8a"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.webserver.id]

  lifecycle {
    create_before_destroy = true
  }

}


resource "aws_security_group" "webserver" {
  name        = "WebServer Security Group"
  description = "My First SecurityGroup"


  dynamic "ingress" {
    for_each = ["80", "443"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "Web Server SecurityGroup"
  }
}
