resource "aws_security_group" "cluster_sg" {
  name        = "${var.name}-${var.environment}-cluster-sg"
  description = "EKS cluster control plane SG"
  vpc_id      = var.eks_vpc_id.id

  tags = merge(var.tags, {
    Name = "${var.name}-${var.environment}-cluster-sg"
    "kubernetes.io/cluster/${var.name}-${var.environment}" = "shared"
  })
}

# Control plane accepts HTTPS from nodes
resource "aws_security_group_rule" "cluster_ingress_nodes" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.cluster_sg.id
  source_security_group_id = aws_security_group.worker_node_sg.id
  description              = "Nodes to API server"
}

resource "aws_security_group_rule" "cluster_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cluster_sg.id
}