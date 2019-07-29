# # Creates an RDS MS SQL Database Instance

resource "aws_db_subnet_group" "terra_db_subnet" {
  name        = "terra_db_subs"
  description = "MS SQL RDS subnet group"
  subnet_ids  = ["${aws_subnet.terra_private_1.id}", "${aws_subnet.terra_private_2.id}"]
  tags = {
    Name = "terra_db_sub"
  }
}


resource "aws_db_instance" "terra_mssql_db" {
  allocated_storage = 20
  engine            = "sqlserver-ex"
  engine_version    = "14.00"
  license_model     = "license-included" # (MY SQL = "license-included" / MySQL = "general-public-license")
  instance_class    = "db.t2.micro"
  identifier        = "mssql-test"
  #name                   = "mssql"
  username               = "root"         # username
  password               = "testdatabase" # password
  db_subnet_group_name   = "${aws_db_subnet_group.terra_db_subnet.name}"
  multi_az               = "false" # True = to obtain high availability where 2 instances sync with each other.
  vpc_security_group_ids = ["${aws_security_group.allow_mssql.id}"]
  storage_type           = "standard"
  #backup_retention_period = 30
  apply_immediately   = true
  availability_zone   = "${aws_subnet.terra_private_1.availability_zone}"
  skip_final_snapshot = true

  tags = {
    Name = "test_mssql_db"
  }
}


# Work in progress: there are issues with the combination of the engine/version/instance class for some reason. 
