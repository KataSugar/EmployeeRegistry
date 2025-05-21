variable "aws_region" {
  description = "The AWS region to deploy the resources in"
  type        = string
  default     = "eu-west-3"
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "registry-eks-cluster"
}

variable "aws_account_id" {
  description = "The AWS account ID"
  type        = string
  default     = "940482431327"
}

variable "configure_kubectl" {
  description = "Whether to configure kubectl for the EKS cluster"
  type        = bool
  default     = true
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_a_cidr" {
  description = "CIDR block for subnet A"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_b_cidr" {
  description = "CIDR block for subnet B"
  type        = string
  default     = "10.0.2.0/24"
}

variable "az_a" {
  description = "Availability Zone A"
  type        = string
  default     = "eu-west-3a"
}

variable "az_b" {
  description = "Availability Zone B"
  type        = string
  default     = "eu-west-3b"
}

