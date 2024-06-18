vpc_cidr = "192.168.0.0/16"

public_subnets_cidrs = ["192.168.0.0/18", "192.168.64.0/18"]

private_subnets_cidrs = ["192.168.128.0/18", "192.168.192.0/18"]

availability_zones = ["ap-south-1a", "ap-south-1b"]

environment = "Production"

common_tags = {
    "Environment" : "Production"
    "ManagedBy" : "Terraform"
}