resource "aws_vpc" "eks_vpc" {
  cidr_block           = var.eks_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = var.tags
}

resource "aws_subnet" "eks_private_subnet" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.1.0.0/26"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
}

# Internet Gateway for the VPC
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

resource "aws_route_table_association" "eks_public_rt_assoc" {
    subnet_id      = aws_subnet.eks_private_subnet.id
    route_table_id = aws_route_table.eks_public_rt.id
}