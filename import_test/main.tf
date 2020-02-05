

provider "aws" {
  region = "us-west-2"
}
resource "aws_instance" "tf_imported_ec2_a" {
  # ...instance configuration...
}
