vpc_cidr = "172.16.0.0/16"

public_subnets_cidrs = ["172.16.0.0/18", "172.16.64.0/18"]

private_subnets_cidrs = ["172.16.128.0/18", "172.16.192.0/18"]

availability_zones = ["ap-south-1a", "ap-south-1b"]

environment = "Development"

common_tags = {
    "Environment" : "Development"
    "ManagedBy" : "Terraform"
}