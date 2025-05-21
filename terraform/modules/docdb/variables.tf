
variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "registry-eks-cluster"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_a_id" {
    description = "Subnet A ID"
    type        = string
}

variable "subnet_b_id" {
    description = "Subnet B ID"
    type        = string
}

variable "vpc_cidr" {
    description = "CIDR block for the VPC"
    type        = string
    default     = "10.0.0.0/16"
}

variable "eks_node_role_name" {
  type = string
  description = "IAM role name for EKS worker nodes"
}