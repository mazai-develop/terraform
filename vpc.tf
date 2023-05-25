resource "aws_vpc" "mul_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    name : "mul_vpc"
  }
}

# Public Subnets
resource "aws_subnet" "public_1a" {
  vpc_id = aws_vpc.mul_vpc.id

  availability_zone = "ap-northeast-1a"
  cidr_block        = "10.0.1.0/24"

  map_public_ip_on_launch = true

  tags = {
    Name = "mul_public_1a"
  }
}

# Private Subnets
resource "aws_subnet" "private_1a" {
  vpc_id = aws_vpc.mul_vpc.id

  availability_zone = "ap-northeast-1a"
  cidr_block        = "10.0.2.0/24"

  tags = {
    Name = "mul_private_1a"
  }
}

