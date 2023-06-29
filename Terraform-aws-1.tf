# Definicja dostawcy AWS
provider "aws" {
  region = "us-west-2" # Zmień na odpowiednią region
}

# Tworzenie grupy zasobów EC2
resource "aws_instance" "ec2_instance" {
  count         = 5
  # Ubuntu 20.04 LTS AMI ID dla regionu US West 2 
  ami           = "ami-0c94855ba95c71c99" 
  instance_type = "t2.micro"
}

# Tworzenie usługi S3
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "my-s3-bucket" # Zmień na odpowiednią nazwę dla swojego S3
  acl    = "private"
}