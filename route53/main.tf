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

resource "aws_route53_zone" "bigpro_hz" {
  name = "hansenfernando.xyz"
}

resource "aws_route53_zone" "k8s_bigpro_hz" {
  name = "k8s.hansenfernando.xyz"
}

resource "aws_route53_record" "bigpro_hz" {
  allow_overwrite = true
  name            = "k8s.hansenfernando.xyz"
  ttl             = 30
  type            = "NS"
  zone_id         = aws_route53_zone.bigpro_hz.zone_id

  records = [
    aws_route53_zone.k8s_bigpro_hz.name_servers[0],
    aws_route53_zone.k8s_bigpro_hz.name_servers[1],
    aws_route53_zone.k8s_bigpro_hz.name_servers[2],
    aws_route53_zone.k8s_bigpro_hz.name_servers[3],
  ]
}
