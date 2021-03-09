provider "aws" {
  profile = "dev"
  region = "ap-southeast-1"
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "web-access" {
  name = "allow http access"
  description = "this will allow ICMP from instance 2 to instance 1"
  vpc_id = aws_default_vpc.default.id

  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
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

resource "aws_instance" "ins" {
  ami = "ami-0d06583a13678c938"
  instance_type = "t2.micro"
  security_groups = [
    aws_security_group.web-access.name,
    aws_security_group.allow-ssh.name]

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
