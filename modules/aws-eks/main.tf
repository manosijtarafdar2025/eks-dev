module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.24.0"
  # EKS Configurations
  create                   = var.create
  name                     = "${var.name}-${var.environment}"
  kubernetes_version       = var.kubernetes_version
  # Subnet Configuration
  subnet_ids               = var.subnet_ids
  # Security Group Configuration
  create_security_group    = false
  security_group_id        = var.cluster_security_group
  tags                     = var.tags
}