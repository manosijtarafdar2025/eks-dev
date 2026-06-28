# Locals
locals {
  cluster_name = "${var.name}-${var.environment}"
}

# VPC
resource "aws_vpc" "eks_vpc" {
  cidr_block           = var.eks_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = var.tags
}

# Public Subnets
resource "aws_subnet" "eks_public_subnet_a" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.1.0.0/26"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  tags                    = {
    Name                     = "eks-public-a"
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }         
}

resource "aws_subnet" "eks_public_subnet_b" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.1.0.64/26"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true
  tags                    = {
    Name                     = "eks-public-b"
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  } 
}

# Private Subnets
resource "aws_subnet" "eks_private_subnet_a" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.1.0.128/26"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = false
  tags                    = {
    Name                              = "eks-private-a"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "eks_private_subnet_b" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.1.0.192/26"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = false
  tags                    = {
    Name                              = "eks-private-b"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "eks_public_igw" {
    vpc_id = aws_vpc.eks_vpc.id
    tags   = var.tags
}

resource "aws_route_table" "eks_public_rt" {
    vpc_id = aws_vpc.eks_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.eks_public_igw.id
    }
}

resource "aws_route_table_association" "eks_public_a_rt_assoc" {
    subnet_id      = aws_subnet.eks_public_subnet_a.id
    route_table_id = aws_route_table.eks_public_rt.id
}

resource "aws_route_table_association" "eks_public_b_rt_assoc" {
    subnet_id      = aws_subnet.eks_public_subnet_b.id
    route_table_id = aws_route_table.eks_public_rt.id
}

# NAT Gateway
resource "aws_eip" "nat" {
    domain = "vpc"
}

resource "aws_nat_gateway" "eks_nat" {
  subnet_id     = aws_subnet.eks_public_subnet_a.id
  allocation_id = aws_eip.nat.id
  depends_on    = [
    aws_internet_gateway.eks_public_igw
  ]
}

resource "aws_route_table" "eks_private_rt" {
  vpc_id = aws_vpc.eks_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.eks_nat.id
  }
}

resource "aws_route_table_association" "eks_private_a_rt_assoc" {
  subnet_id      = aws_subnet.eks_private_subnet_a.id
  route_table_id = aws_route_table.eks_private_rt.id
}

resource "aws_route_table_association" "eks_private_b_rt_assoc" {
  subnet_id      = aws_subnet.eks_private_subnet_b.id
  route_table_id = aws_route_table.eks_private_rt.id
}