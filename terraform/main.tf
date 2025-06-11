module "vpc" {
  source = "./modules/vpc"
  aws_region = var.aws_region
  
}

module "eks" {
  source             = "./modules/eks"

  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = [module.vpc.subnet_a_id]  #check which one is used!
  private_subnet_ids = [module.vpc.subnet_b_id]
  subnet_a_id        = module.vpc.subnet_a_id
  subnet_b_id        = module.vpc.subnet_b_id
  
  configure_kubectl  = var.configure_kubectl
}

module "ecr" {
  source        = "./modules/ecr"
  aws_region    = var.aws_region
  cluster_name  = var.cluster_name
  aws_account_id = var.aws_account_id
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