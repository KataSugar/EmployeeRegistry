variable "aws_region" {
  description = "AWS region"
  type        = string
    default     = "eu-west-3"
}

variable "aws_account_id" {
  description = "AWS account ID"
  type        = string
  default     = "940482431327"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "registry-eks-cluster"
}