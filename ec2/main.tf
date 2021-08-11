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

resource "aws_subnet" "public_subnet_a" {
  vpc_id            = aws_vpc.bigpro_vpc.id
  cidr_block        = "172.16.0.0/27"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "public-subnet-a"
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id            = aws_vpc.bigpro_vpc.id
  cidr_block        = "172.16.0.32/27"
  availability_zone = "ap-southeast-1b"

  tags = {
    Name = "public-subnet-b"
  }
}

resource "aws_internet_gateway" "bigpro_igw" {
  vpc_id = aws_vpc.bigpro_vpc.id

  tags = {
    Name = "bigpro-igw"
  }
}

resource "aws_route_table" "bigpro_route_table" {
  vpc_id = aws_vpc.bigpro_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.bigpro_igw.id
  }

  tags = {
    Name = "bigpro-route-table"
  }
}
resource "aws_main_route_table_association" "bigpro_main_route" {
  vpc_id         = aws_vpc.bigpro_vpc.id
  route_table_id = aws_route_table.bigpro_route_table.id
}

resource "aws_route_table_association" "assoc_public_a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.bigpro_route_table.id
}

resource "aws_route_table_association" "assoc_public_b" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.bigpro_route_table.id
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

resource "aws_key_pair" "bigpro_keypair" {
  key_name   = "bigpro-keypair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDRwQl+ltFLJ7NTBUhWSjdWKduo1/kOsO3HyE4WETOcI2IhdIuk0KlcqV1oTrp5dG3ExrUcsFObz7Afwe7pgcxEQnjyL+1v5rim+u2kKLtHR/FbOPCsOVFaCykAXb7VKIkqOnfI0p+FE1w8VnHQBqWETown6bXu7Oi9MJlQrDiyZLyJRNymexnuy6/MjBQFtpRDBr2JWnfcZ4aXXnVR7/JG6N0PzFDOe+joh85y8FPSCUoMIWWgH310VGu5oWMU584PplWhYmpaSol9WDIXlWLPGFpRKLvKmbp16/Y9qzAsUcCHs16oYkp0oVgaQv0v/goC9t5rtm3TPWOk6WBmGd01 hansen@hawk"
}

resource "aws_instance" "bigpro_workspace" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.bigpro_keypair.key_name
  subnet_id                   = aws_subnet.public_subnet_a.id
  vpc_security_group_ids      = ["${aws_security_group.bigpro_sg.id}"]
  associate_public_ip_address = var.associate_public_ip_address
  count                       = var.instance_count

  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    delete_on_termination = var.delete_on_termination
  }

  tags = {
    Name = var.tags["name"]
  }

  volume_tags = {
    Name = var.tags["name"]
  }

  provisioner "file" {
    source      = "tools_install.sh"
    destination = "/tmp/tools_install.sh"
    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("./bigpro-keypair.pem")
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/tools_install.sh",
      ". /tmp/tools_install.sh"
    ]
    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("./bigpro-keypair.pem")
    }

  }

}