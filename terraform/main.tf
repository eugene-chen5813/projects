provider "aws" {
  region = "${var.region}"
  shared_credentials_file = "${var.shared_credentials_file}"
  profile = "${var.profile}"
}

resource "aws_instance" "webtest" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "radarjam"
  public_key = "${var.public_key}"

  tags = {
    Name = "ec2"
  }
}