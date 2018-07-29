provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "state_bucket" {
  bucket = "zd-tf-ansible-provisioner"

  tags {
    Name = "Terraform + Ansible POC State Bucket"
  }
}

terraform {
  backend "s3" {
    # Be sure to change this bucket name and region to match an S3 Bucket you have already created!
    bucket = "zd-tf-ansible-provisioner"
    region = "us-west-2"
    key    = "terraform.tfstate"
  }
}
