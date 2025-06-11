
variable "aws_region" {
  type        = string
  description = "AWS region for the EKS cluster"
  default     = "eu-west-3"
}

variable "aws_profile" {
  type        = string
  description = "AWS CLI profile to use"
  default     = "default"
}

variable "configure_kubectl" {
  type        = bool
  description = "Whether to configure kubectl with the EKS cluster"
  default     = true
}