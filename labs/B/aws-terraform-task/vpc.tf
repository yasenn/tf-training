provider "aws" {
  region = "eu-west-2"
}

data "aws_availability_zones" "az_list" {

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "IGW"
  }
}

resource "aws_route_table_association" "a_private_table_association" {
  subnet_id      = aws_subnet.a_private.id
  route_table_id = aws_route_table.route_table_private_a.id
}

resource "aws_route_table_association" "b_private_table_association" {
  subnet_id      = aws_subnet.b_private.id
  route_table_id = aws_route_table.route_table_private_b.id
}

resource "aws_route_table_association" "a_public_table_association" {
  subnet_id      = aws_subnet.a_public.id
  route_table_id = aws_route_table.route_table_public.id
}

resource "aws_route_table_association" "b_public_table_association" {
  subnet_id      = aws_subnet.b_public.id
  route_table_id = aws_route_table.route_table_public.id
}

resource "aws_route_table" "route_table_private_a" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_a.id
  }

  tags = {
    Name = "Private A RT"
  }
}

resource "aws_route_table" "route_table_private_b" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_b.id
  }

  tags = {
    Name = "Private B RT"
  }
}

resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = " Public RT"
  }
}

resource "aws_eip" "eip_a" {

  vpc = true

  tags = {
    Name = "EIP for NAT A"
  }
}

resource "aws_eip" "eip_b" {

  vpc = true

  tags = {
    Name = "EIP for NAT B"
  }
}

resource "aws_nat_gateway" "nat_a" {
  subnet_id     = aws_subnet.a_public.id
  allocation_id = aws_eip.eip_a.id

  tags = {
    Name = "NAT A"
  }
}

resource "aws_nat_gateway" "nat_b" {
  subnet_id     = aws_subnet.b_public.id
  allocation_id = aws_eip.eip_b.id

  tags = {
    Name = "NAT B"
  }
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "Main VPC"
  }
}

resource "aws_subnet" "a_private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"
  availability_zone = data.aws_availability_zones.az_list.names[0]

  tags = {
    Name = "A Private SN"
  }
}

resource "aws_subnet" "b_private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.az_list.names[1]

  tags = {
    Name = "B Private SN"
  }
}

resource "aws_subnet" "a_public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.az_list.names[0]

  tags = {
    Name = "A Public SN"
  }
}

resource "aws_subnet" "b_public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = data.aws_availability_zones.az_list.names[1]

  tags = {
    Name = "B Public SN"
  }
}

resource "aws_db_subnet_group" "mysql" {
  name = "mysql_group"
  subnet_ids = [
    aws_subnet.a_private.id,
    aws_subnet.b_private.id]

  tags = {
    Name = "MySQL SN Group"
  }
}