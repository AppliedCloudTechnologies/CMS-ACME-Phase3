provider "aws" {
  region = "us-east-2"
}

resource "aws_vpc" "api_ecs" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "ansong844-api-ecs-vpc"
  }
}

resource "aws_internet_gateway" "api_ecs" {
  vpc_id = aws_vpc.api_ecs.id

  tags = {
    Name = "ansong844-api-ecs-igw"
  }
}

resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.api_ecs.id
  availability_zone       = "us-east-2a"
  cidr_block              = "10.0.32.0/20"
  map_public_ip_on_launch = true

  tags = {
    Name = "ansong844-public-subnet-1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.api_ecs.id
  availability_zone       = "us-east-2b"
  cidr_block              = "10.0.48.0/20"
  map_public_ip_on_launch = true

  tags = {
    Name = "ansong844-public-subnet-2"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.api_ecs.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.api_ecs.id
  }

  tags = {
    Name = "ansong844-public-rtb"
  }
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}
