module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.24.0"
  # EKS Configurations
  create             = var.create["dev"]
  name               = "${var.name}-${var.environment}"
  kubernetes_version = var.kubernetes_version
  tags               = var.tags
}