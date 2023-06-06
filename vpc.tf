resource "aws_vpc" "tns_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "tns_vpc"
  }
}

# Public Subnets
resource "aws_subnet" "public_1a" {
  vpc_id = aws_vpc.tns_vpc.id

  availability_zone = "ap-northeast-1a"
  cidr_block        = "10.0.1.0/24"

  map_public_ip_on_launch = true

  tags = {
    Name = "tns_public_1a"
  }
}

# Public Subnets
resource "aws_subnet" "public_1c" {
  vpc_id = aws_vpc.tns_vpc.id

  availability_zone = "ap-northeast-1c"
  cidr_block        = "10.0.2.0/24"

  map_public_ip_on_launch = true

  tags = {
    Name = "tns_public_1c"
  }
}

# Private Subnets
resource "aws_subnet" "private_1a" {
  vpc_id = aws_vpc.tns_vpc.id

  availability_zone = "ap-northeast-1a"
  cidr_block        = "10.0.3.0/24"

  tags = {
    Name = "mul_private_1a"
  }
}

