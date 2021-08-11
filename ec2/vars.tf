variable "region" {
  default = "ap-southeast-1"
}
variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "ami" {
  default = "ami-0d058fe428540cd89"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "root_volume_size" {
  default = 25
}
variable "root_volume_type" {
  default = "gp2"
}
variable "delete_on_termination" {
  default = true
}
variable "instance_count" {
  default = 1
}
variable "associate_public_ip_address" {
  default = true
}
variable "tags" {
  type = map(string)
  default = {
    "name" = "bigpro-workspace"
  }
}