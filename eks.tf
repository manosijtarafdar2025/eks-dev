module "eks-dev" {
  source                   = "./modules/aws-eks"
  create                   = var.create
  name                     = var.name
  kubernetes_version       = var.kubernetes_version
  environment              = var.environment
  tags                     = var.tags
  subnet_ids               = [aws_subnet.eks_private_subnet]
}