provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "myexample"{
  ami           = "ami-06d51e91cea0dac8d"
  instance_type = "t2.micro"
}

