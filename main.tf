provider "aws" {
  profile = "dev"
  region = "ap-southeast-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0d06583a13678c938"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleInstance"
  }
}