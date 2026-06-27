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
  default = true
}

variable "name" {
  description = "Name of the EKS cluster"
  type = string
  default = "eks-dev"  
}

variable "kubernetes_version" {
  description = "Kubernetes version of the EKS cluster"
  type = string
  default = "1.33"
}