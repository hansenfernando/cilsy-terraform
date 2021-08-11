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

resource "aws_s3_bucket" "bigpro_cilsy_bucket" {
  bucket = "cilsy-k8s-cluster.hansenfernando.xyz"
  acl    = "private"

  tags = {
    Name = "bigpro_cilsy"
  }
}
