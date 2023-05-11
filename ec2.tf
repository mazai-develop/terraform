provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_instance" "ec2" {
  ami           = "ami-079a2a9ac6ed876fc"
  instance_type = "t3a.micro"
  vpc_security_group_ids = ["${aws_security_group.mul_security_group.id}"]
  subnet_id              = "${aws_subnet.public_1a.id}"
  key_name      = aws_key_pair.key_pair.id
}

resource "aws_eip" "mul_eip" {
  instance = aws_instance.ec2.id
  vpc      = true
}

output "public_ip" {
  value       = aws_instance.ec2.public_ip
}
