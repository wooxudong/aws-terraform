provider "aws" {
  profile = "dev"
  region = "ap-southeast-1"
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "sec-group-1" {
  name = "allow ICMP - 1"
  description = "this will allow ICMP from instance 2 to instance 1"
  vpc_id = aws_default_vpc.default.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "sec-group-rule-1" {
  type = "ingress"
  from_port = 8
  to_port = 0
  protocol = "icmp"
  security_group_id = aws_security_group.sec-group-1.id
  source_security_group_id = aws_security_group.sec-group-2.id
}

resource "aws_security_group" "sec-group-2" {
  name = "allow ICMP - 2"
  description = "this will allow ICMP from instance 1 to instance 2"
  vpc_id = aws_default_vpc.default.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "sec-group-rule-2" {
  type = "ingress"
  from_port = 8
  to_port = 0
  protocol = "icmp"
  security_group_id = aws_security_group.sec-group-2.id
  source_security_group_id = aws_security_group.sec-group-1.id
}

resource "aws_security_group" "allow-ssh" {
  name = "allow ssh"
  description = "this will enable ssh"
  vpc_id = aws_default_vpc.default.id
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}

resource "aws_instance" "ins-1" {
  ami = "ami-0d06583a13678c938"
  instance_type = "t2.micro"
  security_groups = [
    aws_security_group.sec-group-1.name,
    aws_security_group.allow-ssh.name]

  tags = {
    Name = "Instance 1"
  }
}

resource "aws_instance" "ins-2" {
  ami = "ami-0d06583a13678c938"
  instance_type = "t2.micro"
  security_groups = [
    aws_security_group.sec-group-2.name,
    aws_security_group.allow-ssh.name]

  tags = {
    Name = "Instance 2"
  }
}