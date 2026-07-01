variable tags {
    description = "Tags to apply to resources"
    type = map(any)
    default = {
        "Environment"      = "dev"
        "EKS Cluster Name" = "eks-dev"
    }
}

variable "environment" {
  description = "EKS environment"
  type = string
  default = "dev"
}

variable "create" {
  description = "Create EKS cluster and related resources"
  type = bool
  default = false
}

variable "name" {
  description = "Name of the EKS cluster"
  type = string
  default = "eks"  
}

variable "kubernetes_version" {
  description = "Kubernetes version of the EKS cluster"
  type = string
  default = "1.33"
}

variable "eks_vpc_cidr" {
    description = "CIDR block for the VPC"
    type        = string
    default     = "10.1.0.0/24"
}