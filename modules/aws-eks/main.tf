module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.24.0"
  # EKS Configurations
  create                   = var.create
  name                     = "${var.name}-${var.environment}"
  kubernetes_version       = var.kubernetes_version
  # Subnet Configuration
  subnet_ids               = var.subnet_ids
  tags                     = var.tags
}