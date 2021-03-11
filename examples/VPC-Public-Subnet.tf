# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Create my own VPC and a public subnet under this VPC. assign the route table to configure internet access outbound
# and route locally for instances within subnet.
# @author: wooxudong
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


resource "aws_vpc" "main" {
  cidr_block = "172.32.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "MY VPC"
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "My IG"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }
  tags = {
    Name = "My public route table"
  }
}


resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
  cidr_block = "172.32.0.0/24"
  availability_zone = "ap-southeast-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "My Public Subnet"
  }
}

resource "aws_route_table_association" "public-rt" {
  route_table_id = aws_route_table.public.id
  subnet_id = aws_subnet.public.id
}

resource "aws_main_route_table_association" "public-main-rt" {
  route_table_id = aws_route_table.public.id
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group" "web-access" {
  name = "allow http access"
  description = "this will allow ICMP from instance 2 to instance 1"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]

  }
}

resource "aws_instance" "ins" {
  ami = "ami-075a72b1992cb0687"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public.id
  vpc_security_group_ids = [
    aws_security_group.web-access.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install httpd -y
              systemctl start httpd
              systemctl enable httpd
              cd /var/www/html
              echo "This is a test page for fun" >> index.html
              EOF
  tags = {
    Name = "Simple Web Server"
  }
}

output "instance_public_ip" {
  value = aws_instance.ins.public_ip
}
