resource "aws_route_table" "mul_route_table" {
  vpc_id = "${aws_vpc.mul_vpc.id}"

  tags = {
    Name = "example"
  }
}

resource "aws_route" "mul_route" {
  gateway_id             = "${aws_internet_gateway.mul_internet_gateway.id}"
  route_table_id         = "${aws_route_table.mul_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "mul_route_table_association" {
  subnet_id      = "${aws_subnet.public_1a.id}"
  route_table_id = "${aws_route_table.mul_route_table.id}"
}