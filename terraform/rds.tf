# # Creates an RDS MS SQL Database Instance

resource "aws_db_subnet_group" "terra_db_subnet" {
  name        = "terra_db_subs"
  description = "MS SQL RDS subnet group"
  subnet_ids  = ["${aws_subnet.terra_private_1.id}", "${aws_subnet.terra_private_2.id}"]
  tags = {
    Name = "terra_db_sub"
  }
}

##########################
# AWS MS SQL DB Instance # 
##########################

# Comment out if you don't want to use this DB Type

# resource "aws_db_instance" "terra_mssql_db" {
#   allocated_storage = 20
#   engine            = "sqlserver-ex"
#   engine_version    = "14.00"
#   license_model     = "license-included" # (MY SQL = "license-included")
#   instance_class    = "db.t2.micro"
#   identifier        = "mssql-test"
#   #name                   = "mssq-testl"
#   username               = "root"         # username
#   password               = "testdatabase" # password
#   db_subnet_group_name   = "${aws_db_subnet_group.terra_db_subnet.name}"
#   multi_az               = "false" # True = to obtain high availability where 2 instances sync with each other.
#   vpc_security_group_ids = ["${aws_security_group.allow_mssql.id}"]
#   storage_type           = "standard"
#   #backup_retention_period = 30
#   apply_immediately   = true
#   availability_zone   = "${aws_subnet.terra_private_1.availability_zone}"
#   skip_final_snapshot = true

#   tags = {
#     Name = "test_mssql_db"
#   }
# }

##########################
# AWS MS SQL DB Instance #
##########################

# Comment out if you don't want to use this DB Type

resource "aws_db_instance" "terra_oracle_db" {
  allocated_storage      = 20
  engine                 = "oracle-se1"
  engine_version         = "11.2.0.4v20"
  license_model          = "license-included" # (Oracle = "bring-your-own-license" or "license-included")
  instance_class         = "db.t2.micro"
  identifier             = "oracle-test"
  name                   = "oracle-test"
  username               = "root"         # username
  password               = "testdatabase" # password
  db_subnet_group_name   = "${aws_db_subnet_group.terra_db_subnet.name}"
  multi_az               = "false" # True = to obtain high availability where 2 instances sync with each other.
  vpc_security_group_ids = ["${aws_security_group.allow_oracle.id}"]
  storage_type           = "standard"
  # backup_retention_period = 30
  apply_immediately   = true
  availability_zone   = "${aws_subnet.terra_private_1.availability_zone}"
  skip_final_snapshot = true

  tags = {
    Name = "test_oracle_db"
  }
}
