resource "aws_route_table" "tns_route_table" {
  vpc_id = aws_vpc.tns_vpc.id

  tags = {
    Name = "tns_route_table"
  }
}

resource "aws_route" "tns_route" {
  gateway_id             = aws_internet_gateway.tns_internet_gateway.id
  route_table_id         = aws_route_table.tns_route_table.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.tns_route_table.id
}

resource "aws_route_table_association" "public_1c" {
  subnet_id      = aws_subnet.public_1c.id
  route_table_id = aws_route_table.tns_route_table.id
}