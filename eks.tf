module "eks-dev" {
  source                 = "./modules/aws-eks"
  create                 = var.create
  name                   = var.name
  kubernetes_version     = var.kubernetes_version
  environment            = var.environment
  eks_vpc_id             = aws_vpc.eks_vpc
  subnet_ids             = [
    aws_subnet.eks_private_subnet_a.id,
    aws_subnet.eks_private_subnet_b.id,
  ]
  tags                   = var.tags
}