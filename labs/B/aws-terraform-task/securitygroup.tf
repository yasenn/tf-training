resource aws_security_group "mysql" {
  name        = "MySQL SG"
  description = "by Terraform"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "MySQL SG"
  }

  ingress {
    protocol        = "tcp"
    from_port       = 3306
    to_port         = 3306
    security_groups = ["${aws_security_group.web.id}"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource aws_security_group "web" {
  name        = "WebServer SG"
  description = "by Terraform"
  vpc_id      = "${aws_vpc.main.id}"

  tags = {
    Name = "WebServer SG"
  }

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource aws_security_group "LoadBalancer" {
  name        = "LoadBalancer SG"
  description = "by Terraform"
  vpc_id      = "${aws_vpc.main.id}"

  tags = {
    Name = "LoadBalancer SG"
  }

  ingress {
    protocol    = "icmp"
    from_port   = -1
    to_port     = -1
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource aws_security_group "AccessToEFS" {
  name        = "AccessToEFS"
  description = "by Terraform"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "AccessToEFS"
  }

  ingress {
    protocol        = "tcp"
    from_port       = 2049
    to_port         = 2049
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}