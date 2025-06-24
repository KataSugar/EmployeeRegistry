
variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
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

variable "eks_node_role_name" {
  type = string
  description = "IAM role name for EKS worker nodes"
}
variable "master_username" {
  description = "Master username for DocumentDB"
  type        = string
  sensitive   = true
}

variable "allowed_security_groups" {
  description = "List of security groups allowed to access DocumentDB"
  type        = list(string)
}