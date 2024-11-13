resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1"
}
resource "aws_network_interface" "test" {
  subnet_id       = aws_subnet.public.id
  private_ips     = ["10.0.1.0"]
  security_groups = [aws_security_group.rds_sg.id]

  attachment {
    instance     = aws_instance.wordpress.id
    device_index = 1
  }
}

resource "aws_internet_gateway" "public_gateway" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public_gateway.id
  }
}

resource "aws_route_table_association" "wp_route_table_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_route_table.id
}
