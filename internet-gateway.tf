resource "aws_internet_gateway" "mul_internet_gateway" {
  vpc_id = aws_vpc.mul_vpc.id

  tags = {
    Name = "mul_internet_gateway"
  }
}