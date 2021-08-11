terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  required_version = ">= 1.0.2"
}

provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_vpc" "bigpro_vpc" {
  cidr_block           = "172.16.0.0/24"
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"

  tags = {
    Name = "bigpro-vpc"
  }
}

resource "aws_security_group" "bigpro_sg" {
  name        = "allow_all_traffic"
  description = "Allow all traffic for cilsy big project"
  vpc_id      = aws_vpc.bigpro_vpc.id

  ingress {
    description = "All Traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bigpro_cilsy_sg"
  }
}

resource "aws_db_instance" "big_pro_cilsydb" {
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  identifier             = var.identifier
  username               = var.username
  password               = var.password
  parameter_group_name   = var.parameter_group_name
  publicly_accessible    = var.publicly_accessible
  vpc_security_group_ids = ["${aws_security_group.bigpro_sg.id}"]
  db_subnet_group_name   = aws_db_subnet_group.big_pro_cilsydbsubnetgroup.id
  skip_final_snapshot    = var.skip_final_snapshot

  tags = {
    Name = "bigpro cilsy db server"
  }
}

resource "aws_db_subnet_group" "big_pro_cilsydbsubnetgroup" {
  name       = "bigpro-cilsydb-subnetgroup"
  subnet_ids = ["subnet-061a54303aefac934", "subnet-0c667b9c1c4b568f9"]

  tags = {
    Name = "bigpro cilsy db subnet group"
  }
}
