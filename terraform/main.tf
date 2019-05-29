provider "aws" {
  region = "${var.region}"
  shared_credentials_file = "${var.shared_credentials_file}"
  profile = "${var.profile}"
}

#Sets up VPC
resource "aws_vpc" "terra_vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  tags = {
    Name = "terra_vpc"
   }
}

#Creates a subnet for VPC
resource "aws_subnet" "terra_subnet" {
  vpc_id = "${aws_vpc.terra_vpc.id}"
  cidr_block = "${var.vpc_cidr}"
  availability_zone = "${var.availability_zone}"
  tags = {
    Name = "terra_subs"
   }
}

#Creates a gateway for VPC
resource "aws_internet_gateway" "terra_gw" {
  vpc_id = "${aws_vpc.terra_vpc.id}"
  tags = {
    Name = "terra_gw"
   }
}

#Creates a routing table for VPC
resource "aws_route_table" "terra_rt" {
  vpc_id = "${aws_vpc.terra_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.terra_gw.id}"
  }

  tags = {
    Name = "terra_rt"
   }
}

# Creates routing table association
resource "aws_route_table_association" "web-public-rt" {
  subnet_id = "${aws_subnet.terra_subnet.id}"
  route_table_id = "${aws_route_table.terra_rt.id}"
}

#Creates terra_sg - security group with port ingress
resource "aws_security_group" "terra_sg" {
  name = "terra_vpc_test"
  description = "Allow incoming HTTP Connections & SSH Access"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = "${aws_vpc.terra_vpc.id}"
    
  tags = {
    Name = "terra_sg"
   }
}

# Adds hostmachine's keypair to enable SSH
resource "aws_key_pair" "terra_vpc" {
  key_name = "terra_vpc_test"
  public_key = "${file("${var.key_path}")}"
}

#Deploys AWS Instance called: Terra_ec2_test
resource "aws_instance" "terra_ec2" {
   ami  = "${var.ami}"
   instance_type = "${var.instance_type}"
   key_name = "${aws_key_pair.terra_vpc.id}"
   subnet_id = "${aws_subnet.terra_subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.terra_sg.id}"]
   #security_groups = ["${aws_security_group.terra_sg.Name}"]
   associate_public_ip_address = true
   source_dest_check = false

   root_block_device {}

   tags = {
    Name = "terra_ec2_test"
   }
}