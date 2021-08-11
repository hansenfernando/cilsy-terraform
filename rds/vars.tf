variable "region" {
  default = "ap-southeast-1"
}
variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "identifier" {
  default = "cilsybigprodb"
}

variable "engine" {
  default = "mysql"
}

variable "engine_version" {
  default = "5.7.34"
}

variable "instance_class" {
  default = "db.t2.micro"
}

variable "allocated_storage" {
  default = 20
}

variable "username" {
  default = "root"
}

variable "password" {
  default = "bigprocilsy"
}

variable "parameter_group_name" {
  default = "default.mysql5.7"
}

variable "publicly_accessible" {
  default = true
}

variable "skip_final_snapshot" {
  default = true
}