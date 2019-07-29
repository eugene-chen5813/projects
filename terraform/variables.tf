variable "region" {
  default = "us-west-1"
}

variable "shared_credentials_file" {
  default = "~/.aws/credentials"
}

variable "profile" {
  default = "radarjam"
}

variable "ami" {
  default = "ami-074e2d6769f445be5"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

variable "vpc_cidr" {
  default = "10.0.1.0/24"
}

variable "vpc_cidr_two" {
  default = "10.0.2.0/24"
}

variable "availability_zone" {
  default = "us-west-1b"
}

variable "availability_zone_two" {
  default = "us-west-1c"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "key_path" {
  default = "~/.ssh/id_rsa.pub"
}
