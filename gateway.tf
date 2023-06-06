resource "aws_internet_gateway" "tns_internet_gateway" {
  vpc_id = aws_vpc.tns_vpc.id

  tags = {
    Name = "tns_internet_gateway"
  }
}

# nat gateway in subnet
resource "aws_eip" "nat_1a" {
  vpc = true

  tags = {
    Name = "tns_eip_1a"
  }
}

resource "aws_nat_gateway" "nat_1a" {
  subnet_id     = "${aws_subnet.public_1a.id}" # NAT Gatewayを配置するSubnetを指定
  allocation_id = "${aws_eip.nat_1a.id}"       # 紐付けるElasti IP

  tags = {
    Name = "tns_natgw_1a"
  }
}

# nat gateway in subnet
resource "aws_eip" "nat_1c" {
  vpc = true

  tags = {
    Name = "tns_eip_1c"
  }
}

resource "aws_nat_gateway" "nat_1c" {
  subnet_id     = "${aws_subnet.public_1c.id}" # NAT Gatewayを配置するSubnetを指定
  allocation_id = "${aws_eip.nat_1c.id}"       # 紐付けるElasti IP

  tags = {
    Name = "tns_natgw_1c"
  }
}