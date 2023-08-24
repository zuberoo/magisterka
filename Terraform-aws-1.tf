# Definicja dostawcy AWS
provider "aws" {
  region = "us-west-2" # Zmień na odpowiednią region
}


resource "aws_instance" "ec2_instance" {
  count         = 5
  
  ami           = "ami-0c94855ba95c71c99" 
  instance_type = "t2.micro"
}


resource "aws_s3_bucket" "s3_bucket" {
  bucket = "my-s3-bucket" 
  acl    = "private"
}