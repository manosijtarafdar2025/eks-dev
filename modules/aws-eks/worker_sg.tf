resource "aws_security_group" "worker_node_sg" {
  name        = "${var.name}-${var.environment}-node-sg"
  description = "EKS worker node SG"
  vpc_id      = var.eks_vpc_id.id

  tags = merge(var.tags, {
    Name = "${var.name}-${var.environment}-node-sg"
    "kubernetes.io/cluster/${var.name}-${var.environment}" = "owned"
  })
}

# Nodes talk to each other (pod-to-pod, CNI)
resource "aws_security_group_rule" "node_self" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  self              = true
  security_group_id = aws_security_group.worker_node_sg.id
  description       = "Inter-node communication"
}

# Control plane reaches kubelet + NodePort range
resource "aws_security_group_rule" "node_ingress_cluster" {
  type                     = "ingress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.worker_node_sg.id
  source_security_group_id = aws_security_group.cluster_sg.id
  description              = "Control plane to kubelet and NodePorts"
}

# Control plane reaches admission webhooks (Kyverno, etc.)
resource "aws_security_group_rule" "node_ingress_cluster_webhooks" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.worker_node_sg.id
  source_security_group_id = aws_security_group.cluster_sg.id
  description              = "Control plane webhooks to nodes"
}

# Nodes reach ECR, S3, SSM, AWS APIs
resource "aws_security_group_rule" "node_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.worker_node_sg.id
}