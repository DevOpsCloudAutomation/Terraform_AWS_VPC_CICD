variable "aws_region" {
  type        = string
  default     = "ap-south-1"
  description = "Select AWS Region where Resources to be Provisioned"
}

variable "vpc_cidr" {
  type        = string
  default     = "192.168.0.0/16"
  description = "CIDR Range for Virtual Private Cloud"
}

variable "enable_dns_hostnames" {
  type        = bool
  default     = true
  description = "Enable DNS Hostnames to True"
}

variable "enable_dns_support" {
  type        = bool
  default     = true
  description = "Enable DNS Support to True"
}

variable "common_tags" {
  type = map(string)
  default = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }

  description = "Common Tags for all VPC Resources"
}

variable "project_name" {
  type        = string
  default     = "Amazon"
  description = "Project Name for Virtual Private Cloud"
}

variable "environment" {
  type        = string
  default     = "Production"
  description = "Environment for Virtual Private Cloud"
}

variable "public_subnets_cidrs" {
  type        = list(string)
  default     = ["192.168.0.0/18", "192.168.64.0/18"]
  description = "Public Subnet CIDRs for Virtual Private Cloud"
}

variable "availability_zones" {
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
  description = "Availability Zones for Virtual Private Cloud"
}

variable "map_public_ip_on_launch" {
  type        = bool
  default     = true
  description = "Assing Public IP for Servers Provisioned in Public Subnets"
}

variable "private_subnets_cidrs" {
  type        = list(string)
  default     = ["192.168.128.0/18", "192.168.192.0/18"]
  description = "Private Subnet CIDRs for Vitual Private Cloud"
}