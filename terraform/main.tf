provider "aws" {
  region = "${var.region}"
  # shared_credentials_file = "${var.shared_credentials_file}"
  profile = "${var.profile}"
}


# Internet VPC
resource "aws_vpc" "terra_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"

  tags = {
    Name = "terra_vpc"
  }
}

# Private and Public Subnets
resource "aws_subnet" "terra_public_1" {
  vpc_id                  = "${aws_vpc.terra_vpc.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-west-1b"

  tags = {
    Name = "terra_public_1"
  }
}
resource "aws_subnet" "terra_public_2" {
  vpc_id                  = "${aws_vpc.terra_vpc.id}"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-west-1c"

  tags = {
    Name = "terra_public_2"
  }
}
resource "aws_subnet" "terra_private_1" {
  vpc_id                  = "${aws_vpc.terra_vpc.id}"
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-west-1b"

  tags = {
    Name = "terra_private_1"
  }
}
resource "aws_subnet" "terra_private_2" {
  vpc_id                  = "${aws_vpc.terra_vpc.id}"
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-west-1c"

  tags = {
    Name = "terra_private_2"
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
  subnet_id      = "${aws_subnet.terra_public_1.id}"
  route_table_id = "${aws_route_table.terra_rt.id}"
}

#Creates terra_sg - security group with port ingress
resource "aws_security_group" "terra_sg" {
  name        = "terra_vpc_test"
  description = "Allow incoming HTTP Connections & SSH Access"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["208.98.205.74/32"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["208.98.205.74/32"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["208.98.205.74/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = "${aws_vpc.terra_vpc.id}"

  tags = {
    Name = "terra_sg"
  }
}

# Creates MS SQL Security Group
resource "aws_security_group" "allow_mssql" {
  vpc_id      = "${aws_vpc.terra_vpc.id}"
  name        = "allow_mssql"
  description = "Allows MS SQL"

  ingress {
    from_port       = 1433
    to_port         = 1433
    protocol        = "tcp"
    security_groups = ["${aws_security_group.terra_sg.id}"] # allowing access from our example instance
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }
  tags = {
    Name = "allow_mssql"
  }
}

# Creates an Oracle Security Group
resource "aws_security_group" "allow_oracle" {
  vpc_id      = "${aws_vpc.terra_vpc.id}"
  name        = "allow_oracle"
  description = "Allows Oracle"

  ingress {
    from_port       = 1521
    to_port         = 1521
    protocol        = "tcp"
    security_groups = ["${aws_security_group.terra_sg.id}"] # allowing access from our example instance
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }
  tags = {
    Name = "allow_oracle"
  }
}

# Adds hostmachine's keypair to enable SSH
resource "aws_key_pair" "terra_vpc" {
  key_name   = "terra_vpc_test"
  public_key = "${file("${var.key_path}")}"
}

# Deploys AWS Instance called: Terra_ec2_test
resource "aws_instance" "terra_ec2" {
  ami                    = "${var.ami}"
  instance_type          = "${var.instance_type}"
  key_name               = "${aws_key_pair.terra_vpc.id}"
  subnet_id              = "${aws_subnet.terra_public_1.id}"
  vpc_security_group_ids = ["${aws_security_group.terra_sg.id}"]
  #security_groups = ["${aws_security_group.terra_sg.Name}"]
  associate_public_ip_address = true
  source_dest_check           = false

  root_block_device {}

  tags = {
    Name = "terra_ec2_test"
  }
}
