terraform {
  backend "s3" {
    bucket  = "devopscloudautomation-amazon"
    region  = "ap-south-1"
    profile = "terraform"

    dynamodb_table = "terraform-state-locking"
  }
}