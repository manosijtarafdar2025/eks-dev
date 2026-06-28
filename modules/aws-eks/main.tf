module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.24.0"
  # EKS Configurations
  create             = var.create
  name               = "${var.name}-${var.environment}"
  kubernetes_version = var.kubernetes_version
  # VPC Configuration
  vpc_id             = var.eks_vpc_id.id
  # Security Groups
  create_security_group         = false
  create_node_security_group    = false
  security_group_id             = aws_security_group.cluster_sg.id
  node_security_group_id        = aws_security_group.worker_node_sg.id
  # Subnet Configuration
  subnet_ids               = var.subnet_ids
  tags                     = var.tags
}