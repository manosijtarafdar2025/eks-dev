module "eks-dev" {
  source                 = "./modules/aws-eks"
  create                 = var.create
  name                   = var.name
  kubernetes_version     = var.kubernetes_version
  environment            = var.environment
  subnet_ids             = [
    aws_subnet.eks_private_subnet_a.id,
    aws_subnet.eks_private_subnet_b.id,
  ]
  # cluster_security_group = aws_security_group.eks_cluster_sg.id
  tags                   = var.tags
}