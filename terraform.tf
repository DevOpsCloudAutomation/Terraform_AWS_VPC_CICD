terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.49.0"
    }
  }
  backend "s3" {
    bucket  = "devopscloudautomation-amazon"
    region  = "ap-south-1"
    profile = "terraform"

    dynamodb_table = "terraform-state-locking"
  }
}