variable "create" {
  description = "Create EKS and its related resources"
  type = bool
}

variable "name" {
  description = "Name of the EKS cluster"
  type = string
}

variable "kubernetes_version" {
  description = "Kubernetes version of EKS cluster"
  type = string
}

variable "environment" {
  description = "EKS Environment"
  type = string
}

variable "tags" {
  description = "Default tags"
  type = map(any)
}

variable "subnet_ids" {
  description = "EKS cluster subnet ids"
  type = list(string)
}