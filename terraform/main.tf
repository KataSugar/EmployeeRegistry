module "vpc" {
  source = "./modules/vpc"

  aws_region     = var.aws_region
  vpc_cidr       = var.vpc_cidr
  subnet_a_cidr  = var.subnet_a_cidr
  subnet_b_cidr  = var.subnet_b_cidr
  az_a           = var.az_a
  az_b           = var.az_b
  cluster_name   = var.cluster_name
}

module "eks" {
  source             = "./modules/eks"
  cluster_name       = var.cluster_name
  aws_region         = var.aws_region
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = [module.vpc.subnet_b_id]
  public_subnet_ids = [module.vpc.subnet_a_id]
  subnet_a_id = module.vpc.subnet_a_id
  subnet_b_id = module.vpc.subnet_b_id
  configure_kubectl  = var.configure_kubectl
}

module "ecr" {
  source = "./modules/ecr"

  aws_region     = var.aws_region
  aws_account_id = var.aws_account_id
  cluster_name   = var.cluster_name
}

module "docdb" {
  source        = "./modules/docdb"
  cluster_name  = var.cluster_name
  vpc_id        = module.vpc.vpc_id
  subnet_a_id   = module.vpc.subnet_a_id
  subnet_b_id   = module.vpc.subnet_b_id
  vpc_cidr      = module.vpc.vpc_cidr
  eks_node_role_name = module.eks.node_role_name
}