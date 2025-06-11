terraform {
    required_providers {
        aws = {
          source  = "hashicorp/aws"
          version = "~> 5.83"
        }
        kubernetes = {
            source  = "hashicorp/kubernetes"
            version = "~> 2.36"
        }
        helm = {
            source  = "hashicorp/helm"
            version = "~> 2.10"
        }
    }
    
    required_version = ">= 1.2.0"
}

provider "aws" {
    region = var.aws_region
}

provider "kubernetes" {
    host                   = data.aws_eks_cluster.cluster.endpoint
    token                  = data.aws_eks_cluster_auth.cluster.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
   
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    token                  = data.aws_eks_cluster_auth.cluster.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  }
}
