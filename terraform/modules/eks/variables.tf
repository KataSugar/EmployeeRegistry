variable "aws_region" {
  description = "The AWS region to deploy the resources in"
  type        = string
  default     = "eu-west-3"  #remove default?
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "registry-eks-cluster"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "configure_kubectl" {
  description = "Whether to configure kubectl for the EKS cluster"
  type        = bool
  default     = true
}

variable "subnet_a_id" { 
  type = string 
  description = "Subnet A ID"
}

variable "subnet_b_id" { 
  type = string 
  description = "Subnet B ID"
}