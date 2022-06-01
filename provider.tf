provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    region = "us-east-1"
    key    = "k8s-on-aws"
    bucket = "terraformstate20220430"
  }
}