resource "aws_vpc" "wp_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "wp_subnet" {
  vpc_id     = aws_vpc.wp_vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_internet_gateway" "wp_gateway" {
  vpc_id = aws_vpc.wp_vpc.id
}

resource "aws_route_table" "wp_route_table" {
  vpc_id = aws_vpc.wp_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.wp_gateway.id
  }
}

resource "aws_route_table_association" "wp_route_table_assoc" {
  subnet_id      = aws_subnet.wp_subnet.id
  route_table_id = aws_route_table.wp_route_table.id
}
