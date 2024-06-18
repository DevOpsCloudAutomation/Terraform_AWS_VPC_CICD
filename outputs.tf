output "vpc_id" {
  value       = aws_vpc.main.id
  description = "Virtual Private Cloud ID"
}

output "public_subnet_ips" {
  value       = aws_subnet.public_subnets[*].id
  description = "Public Subnets IDs"
}

output "private_subnets_ips" {
  value       = aws_subnet.private_subnets[*].id
  description = "Private Subnet IDs"
}