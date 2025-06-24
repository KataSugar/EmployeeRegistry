#EKS cluster role

data "aws_iam_policy_document" "eks_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name               = "EKS-Cluster-Role"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role_policy.json

}

resource "aws_iam_role_policy_attachment" "cluster_policy_attachment" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  
}

#EKS node role
data "aws_iam_policy_document" "node_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "node" {
  name               = "${var.cluster_name}-node-role"
  assume_role_policy = data.aws_iam_policy_document.node_assume_role_policy.json
}

# locals {
#   node_policy_arns = toset([
#     "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
#     "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
#     "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
#   ])
# }

# resource "aws_iam_role_policy_attachment" "node_policy_attachment" {
#   for_each = local.node_policy_arns
#   role        = aws_iam_role.node.name
#   policy_arn  = each.value
  
# }


 resource "aws_iam_role_policy_attachment" "eks_worker_policy" {
   role       = aws_iam_role.node.name
   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
 }

 resource "aws_iam_role_policy_attachment" "eks_vpc_resource_controller" {
   role       = aws_iam_role.node.name
   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
 }

 resource "aws_iam_role_policy_attachment" "ecr_read_policy" {
   role       = aws_iam_role.node.name
   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
 }


#Addons
## Enables Kubernetes Pods to communicate over AWS VPC network
resource "aws_eks_addon" "vpc_cni" {
  cluster_name = var.cluster_name
  addon_name   = "vpc-cni"   
  depends_on = [ aws_eks_cluster.eks]
}

##Provides DNS resolution for services and pods within the cluster
resource "aws_eks_addon" "coredns" {
  cluster_name = var.cluster_name
  addon_name   = "coredns"
}

##Manages network routing for Kubernetes services, enabling load balancing and service discovery
resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.eks.name
  addon_name   = "kube-proxy"
}

# Give the ability to create aws load balancers as k8s services
resource "aws_eks_addon" "aws_load_balancer_controller" {
  cluster_name = aws_eks_cluster.eks.name
  addon_name   = "aws-load-balancer-controller"
}
