terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "eu-west-2"
}

resource "aws_vpc" "vpc_my" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "vpc_my"
  }
}

resource "aws_internet_gateway" "aigw_my" {
  vpc_id = aws_vpc.vpc_my.id

  tags = {
    Name = "aigw_my"
  }
}

resource "aws_route_table" "art_my" {
  vpc_id = aws_vpc.vpc_my.id

 route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aigw_my.id
  }

#  route {
#    cidr_block = "10.0.128.0/25"
#    gateway_id = aws_internet_gateway.aigw_my.id
#  }
#
#  route {
#    cidr_block = "10.0.128.128/25"
#    gateway_id = aws_internet_gateway.aigw_my.id
#  }
#
  tags = {
    Name = "art_my"
  }
}

resource "aws_subnet" "asn_eu-w-2a_my" {
  vpc_id = aws_vpc.vpc_my.id
  cidr_block = "10.0.128.0/25"
  availability_zone = "eu-west-2a"
  tags = {
    Name = "asn_eu-w-2a_my"
  }
  
}

resource "aws_subnet" "asn_eu-w-2b_my" {
  vpc_id = aws_vpc.vpc_my.id
  cidr_block = "10.0.128.128/25"
  availability_zone = "eu-west-2b"
  tags = {
    Name = "asn_eu-w-2b_my"
  }
  
}

resource "aws_subnet" "asn_efs_eu-w-2a_my" {
  vpc_id = aws_vpc.vpc_my.id
  cidr_block = "10.0.192.0/25"
  availability_zone = "eu-west-2a"
  tags = {
    Name = "asn_efs_eu-w-2a_my"
  }
  
}

resource "aws_subnet" "asn_efs_eu-w-2b_my" {
  vpc_id = aws_vpc.vpc_my.id
  cidr_block = "10.0.192.128/25"
  availability_zone = "eu-west-2b"
  tags = {
    Name = "asn_efs_eu-w-2b_my"
  }
  
}

resource "aws_route_table_association" "arta_eu-w-2a_my" {
  subnet_id      = aws_subnet.asn_eu-w-2a_my.id
  route_table_id = aws_route_table.art_my.id
}

resource "aws_route_table_association" "arta_eu-w-2b_my" {
  subnet_id      = aws_subnet.asn_eu-w-2b_my.id
  route_table_id = aws_route_table.art_my.id
}

resource "aws_route_table_association" "arta_efs_eu-w-2a_my" {
  subnet_id      = aws_subnet.asn_efs_eu-w-2a_my.id
  route_table_id = aws_route_table.art_my.id
}

resource "aws_route_table_association" "arta_efs_eu-w-2b_my" {
  subnet_id      = aws_subnet.asn_efs_eu-w-2b_my.id
  route_table_id = aws_route_table.art_my.id
}


resource "aws_security_group" "asg_eu-w-2a_my" {
  name        = "allow_eu-w-2a_web_ssh"
  description = "Allow web and ssh traffic"
  vpc_id      = aws_vpc.vpc_my.id

  ingress {
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    description = "HTTPS"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "asg_eu-w-2a_my"
  }

}

resource "aws_security_group" "asg_eu-w-2b_my" {
  name        = "allow_eu-w-2b_web_ssh"
  description = "Allow web and ssh traffic"
  vpc_id      = aws_vpc.vpc_my.id

  ingress {
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "asg_eu-w-2b_my"
  }
}

resource "aws_security_group" "asg_elb_my" {
  name        = "allow_elb_web"
  description = "Allow web and icmp traffic"
  vpc_id      = aws_vpc.vpc_my.id

  ingress {
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description = "ICMP"
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "asg_elb_my"
  }
}


resource "aws_security_group" "asg_efs_eu-w-2a_my" {
  name        = "allow_efs_eu-w-2a_icmp_nfs"
  description = "Allow icmp and nfs traffic"
  vpc_id      = aws_vpc.vpc_my.id

  ingress {
    description = "ICMP"
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["10.0.0.0/16"] 
  }

  ingress {
    description = "NFS"
    from_port = 2049
    to_port = 2049
    protocol = "tcp"
    cidr_blocks = ["10.0.128.0/25"] 
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "asg_efs_eu-w-2a_my"
  }

}

resource "aws_security_group" "asg_efs_eu-w-2b_my" {
  name        = "allow_efs_eu-w-2b_icmp_nfs"
  description = "Allow icmp and nfs traffic"
  vpc_id      = aws_vpc.vpc_my.id

  ingress {
    description = "ICMP"
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["10.0.0.0/16"] 
  }

  ingress {
    description = "NFS"
    from_port = 2049
    to_port = 2049
    protocol = "tcp"
    cidr_blocks = ["10.0.128.128/25"] 
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "asg_efs_eu-w-2b_my"
  }

}

resource "aws_security_group" "asg_rds_eu-w-2_my" {
  name        = "allow_rds_eu-w-2_icmp_rds"
  description = "Allow icmp and rds traffic"
  vpc_id      = aws_vpc.vpc_my.id

  ingress {
    description = "ICMP"
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["10.0.0.0/16"] 
  }

  ingress {
    description = "RDS"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"] 
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "asg_rds_eu-w-2_my"
  }

}

resource "aws_network_interface" "ani_eu-w-2a_my" {
  subnet_id       = aws_subnet.asn_eu-w-2a_my.id
  private_ips     = ["10.0.128.50"]
  security_groups = [aws_security_group.asg_eu-w-2a_my.id]
}

resource "aws_network_interface" "ani_eu-w-2b_my" {
  subnet_id       = aws_subnet.asn_eu-w-2b_my.id
  private_ips     = ["10.0.128.150"]
  security_groups = [aws_security_group.asg_eu-w-2b_my.id]

}

#For access checking
resource "aws_eip" "eip_eu-w-2a_my" {
  vpc = true
  network_interface = aws_network_interface.ani_eu-w-2a_my.id
  associate_with_private_ip = "10.0.128.50"
  depends_on =  [aws_internet_gateway.aigw_my]
}

#For access checking
resource "aws_eip" "eip_eu-w-2b_my" {
  vpc = true
  network_interface = aws_network_interface.ani_eu-w-2b_my.id
  associate_with_private_ip = "10.0.128.150"
  depends_on =  [aws_internet_gateway.aigw_my]
}

resource "aws_efs_file_system" "aefs_my" {
  creation_token = "media_my"

  tags = {
    Name = "aefs_my"
  }
}

resource "aws_efs_mount_target" "aemt_eu-w-2a_my" {
  file_system_id = aws_efs_file_system.aefs_my.id
  subnet_id      = aws_subnet.asn_efs_eu-w-2a_my.id
  ip_address = "10.0.192.50"
  security_groups = [aws_security_group.asg_efs_eu-w-2a_my.id]
}

resource "aws_efs_mount_target" "aemt_eu-w-2b_my" {
  file_system_id = aws_efs_file_system.aefs_my.id
  subnet_id      = aws_subnet.asn_efs_eu-w-2b_my.id
  ip_address = "10.0.192.150"
  security_groups = [aws_security_group.asg_efs_eu-w-2b_my.id]
}

resource "aws_db_subnet_group" "adbsug_my" {
  name       = "adbsg_my"
  subnet_ids = [aws_subnet.asn_eu-w-2a_my.id, aws_subnet.asn_eu-w-2b_my.id]

  tags = {
    Name = "adbsg_my"
  }
}

resource "aws_db_instance" "adbi_my" {
  allocated_storage    = 10
  max_allocated_storage = 30
  identifier = "adbimy"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "adbi_mysql_my"
  username             = "root"
  password             = "r00tadmin77"
  db_subnet_group_name   = aws_db_subnet_group.adbsug_my.name
  vpc_security_group_ids = [aws_security_group.asg_rds_eu-w-2_my.id]
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}

#       
resource "aws_instance" "ai_web_eu-w-2a_my" {
  ami           = "ami-03ac5a9b225e99b02"
  instance_type = "t2.micro"
  availability_zone = "eu-west-2a"
  key_name = "aws_test_key" #REPLACE key option!!!

  network_interface {
    network_interface_id = aws_network_interface.ani_eu-w-2a_my.id
    device_index         = 0
  }
  user_data = <<EOF
	    #!/bin/bash
      sudo yum update -y
      sudo mkdir -p /var/www/html
      sudo chattr +i /var/www/html
      sudo mount -t nfs4 10.0.192.50:/ /var/www/html/
		  sudo amazon-linux-extras install -y php7.4 
		  sudo yum install -y httpd
		  sudo systemctl start httpd
      sudo systemctl enable httpd
      sudo usermod -aG apache ec2-user
      sudo chown -R ec2-user:apache /var/www
      curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
		  chmod +x wp-cli.phar
      sudo mv wp-cli.phar /usr/local/bin/wp
      sudo chmod -R 775 /var/www/html/wp-content/
      sudo systemctl restart httpd
	EOF

  tags = {
    Name = "ai_web_eu-w-2a_my"
  }
}
# /wp-admin/install.php 
# /wp-login.php
resource "aws_instance" "ai_web_eu-w-2b_my" {
  ami           = "ami-03ac5a9b225e99b02"
  instance_type = "t2.micro"
  availability_zone = "eu-west-2b"
  key_name = "aws_test_key"

  network_interface {
    network_interface_id = aws_network_interface.ani_eu-w-2b_my.id
    device_index         = 0
  }
  
	user_data = <<EOF
	    #!/bin/bash
      sudo yum update -y
      sudo mkdir -p /var/www/html
      sudo chattr +i /var/www/html
      sudo mount -t nfs4 10.0.192.150:/ /var/www/html/
		  sudo amazon-linux-extras install -y php7.4 
		  sudo yum install -y httpd
		  sudo systemctl start httpd
      sudo systemctl enable httpd
      sudo usermod -aG apache ec2-user
      sudo chown -R ec2-user:apache /var/www
      curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
		  chmod +x wp-cli.phar
      sudo mv wp-cli.phar /usr/local/bin/wp
      cd /var/www/html
      wp core download
      cp wp-config-sample.php wp-config.php
      sed -i 's/database_name_here/adbi_mysql_my/g' wp-config.php
      sed -i 's/username_here/root/g' wp-config.php
      sed -i 's/password_here/r00tadmin77/g' wp-config.php
      sed -i 's/localhost/${aws_db_instance.adbi_my.address}/g' wp-config.php
      wp core install --url=http://${aws_elb.aelbmy.dns_name}/ --title=MyTEST --admin_user=root --admin_password=r00tadmin77 --admin_email=info@example.com
      sudo chown -R ec2-user:apache /var/www
      sudo chmod -R 775 /var/www/html/wp-content/
      sudo systemctl restart httpd
	EOF

  tags = {
    Name = "ai_web_eu-w-2b_my"
  }
}

resource "aws_elb" "aelbmy" {
  name               = "aelbmy"
  #vailability_zones = ["eu-west-2a", "eu-west-2b"]
  subnets = [aws_subnet.asn_eu-w-2a_my.id, aws_subnet.asn_eu-w-2b_my.id]
  security_groups = [aws_security_group.asg_elb_my.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "http"
    #ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/certName"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/wp-login.php"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "aelbmy"
  }
} 

resource "aws_elb_attachment" "aelba_eu-w-2a_my" {
  elb      = aws_elb.aelbmy.id
  instance = aws_instance.ai_web_eu-w-2a_my.id
}

resource "aws_elb_attachment" "aelba_eu-w-2b_my" {
  elb      = aws_elb.aelbmy.id
  instance = aws_instance.ai_web_eu-w-2b_my.id
}


output "url_first_instace" {
  value = "http://${aws_eip.eip_eu-w-2a_my.public_ip}/"
}

output "url_second_instace" {
  value = "http://${aws_eip.eip_eu-w-2b_my.public_ip}/"
}

output "balancer_url" {
  value = "http://${aws_elb.aelbmy.dns_name}/"
}

output "wp_ulr_admin"{
  value = "http://${aws_elb.aelbmy.dns_name}/wp-login.php"
}

output "wp_credential_and_db_credential"{
  value = "login: root, password: r00tadmin77"
}