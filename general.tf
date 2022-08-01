resource "aws_vpc" "custom" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"

  tags = {
    Name = "ACME PROJECT VPC"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.custom.id
}

resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.custom.id
  availability_zone       = "${var.region}a"
  cidr_block              = var.public-subnet
  map_public_ip_on_launch = true
  depends_on              = [aws_internet_gateway.main]
}

resource "aws_subnet" "public-subnet2" {
  vpc_id                  = aws_vpc.custom.id
  availability_zone       = "${var.region}b"
  cidr_block              = var.public-subnet2
  map_public_ip_on_launch = true
  depends_on              = [aws_internet_gateway.main]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.custom.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public-subnet2.id
  route_table_id = aws_route_table.public.id
}
