resource "aws_security_group" "mul_security_group" {
  name   = "mul_security_group"
  vpc_id = aws_vpc.tns_vpc.id
}

# 80番ポート(http)許可のインバウンドルール
resource "aws_security_group_rule" "inbound_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"
  cidr_blocks = [
    "0.0.0.0/0"
  ]

  # ec2セキュリティグループに紐付け
  security_group_id = aws_security_group.mul_security_group.id
}

# 443番ポート許可のインバウンドルール
resource "aws_security_group_rule" "inbound_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"
  cidr_blocks = [
    "0.0.0.0/0"
  ]

  # ここでweb_serverセキュリティグループに紐付け
  security_group_id = aws_security_group.mul_security_group.id
}

# 22番ポート(ssh)許可のインバウンドルール
resource "aws_security_group_rule" "inbound_ssh" {
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"
  cidr_blocks = [
    "0.0.0.0/0"
  ]

  # ec2セキュリティグループに紐付け
  security_group_id = aws_security_group.mul_security_group.id
}

# アウトバウンドルール
resource "aws_security_group_rule" "out_all" {
  type      = "egress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"

  cidr_blocks = [
    "0.0.0.0/0"
  ]

  # ec2セキュリティグループに紐付け
  security_group_id = aws_security_group.mul_security_group.id
}

output "eip" {
  value = aws_eip.mul_eip.public_ip
}