resource "aws_vpc" "cltt_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    "Name" : "codelovers_vpc"
  }
}

resource "aws_subnet" "cltt_public_subnet" {
  vpc_id                  = aws_vpc.cltt_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}a"
  tags = {
    "Name" = "codelovers_public_subnet"
  }
}

resource "aws_subnet" "cltt_public_subnet_for_alb" {
  vpc_id                  = aws_vpc.cltt_vpc.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}b"
  tags = {
    "Name" = "codelovers_public_subnet_for_alb"
  }
}

resource "aws_route_table" "cltt_public_rt" {
  vpc_id = aws_vpc.cltt_vpc.id
  tags = {
    "Name" = "codelovers_public_rt"
  }
}

resource "aws_route" "cltt_route" {
  route_table_id         = aws_route_table.cltt_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.cltt_internet_gateway.id
}

resource "aws_route_table_association" "cltt_public_assoc" {
  subnet_id      = aws_subnet.cltt_public_subnet.id
  route_table_id = aws_route_table.cltt_public_rt.id
}

resource "aws_internet_gateway" "cltt_internet_gateway" {
  vpc_id = aws_vpc.cltt_vpc.id
  tags = {
    "Name" = "cltt_ig"
  }
}
