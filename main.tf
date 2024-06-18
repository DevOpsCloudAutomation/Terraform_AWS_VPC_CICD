resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge({ "Name" = "${local.name}-VPC" }, var.common_tags)
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge({ "Name" = "${local.name}-VPC-IGW" }, var.common_tags)
}

resource "aws_subnet" "public_subnets" {
  vpc_id = aws_vpc.main.id

  count = length(var.public_subnets_cidrs)

  cidr_block        = element(var.public_subnets_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)

  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge({ "Name" = "${local.name}-VPC-PublicSubnet-${count.index + 1}" }, var.common_tags)
}

resource "aws_subnet" "private_subnets" {
  vpc_id = aws_vpc.main.id

  count = length(var.private_subnets_cidrs)

  cidr_block        = element(var.private_subnets_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = merge({ "Name" = "${local.name}-VPC-PrivateSubnet-${count.index + 1}" }, var.common_tags)
}

resource "aws_route_table" "public_route_tables" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge({ "Name" = "${local.name}-VPC-PublicRouteTable" }, var.common_tags)
}

resource "aws_route_table_association" "public_route_table_association" {
  count = length(var.public_subnets_cidrs)

  route_table_id = aws_route_table.public_route_tables.id
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)

  //or
  //subnet_id = aws_subnet.public_subnets[count.index].id
}

resource "aws_eip" "nat_elastic_ips" {
  count  = length(var.public_subnets_cidrs)
  domain = "vpc"

  tags = merge({ "Name" = "${local.name}-elastic-ip-${count.index + 1}" }, var.common_tags)
}

resource "aws_nat_gateway" "nat_gateway" {
  count = length(var.public_subnets_cidrs)

  allocation_id = element(aws_eip.nat_elastic_ips[*].id, count.index)
  subnet_id     = element(aws_subnet.public_subnets[*].id, count.index)

  tags = merge({ "Name" = "${local.name}-VPC-NAT-Gateway-${count.index + 1}" }, var.common_tags)

  depends_on = [aws_internet_gateway.main]
}

resource "aws_route_table" "private_route_tables" {
  count = length(var.private_subnets_cidrs)

  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.nat_gateway[*].id, count.index)
  }

  tags = merge({ "Name" = "${local.name}-VPC-PrivateRouteTable-${count.index + 1}" }, var.common_tags)
}

resource "aws_route_table_association" "private_route_tables_association" {
  count = length(var.private_subnets_cidrs)

  route_table_id = element(aws_route_table.private_route_tables[*].id, count.index)
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)

  //or
  //subnet_id = element((aws_subnet.private_subnets[count.in].id))
}