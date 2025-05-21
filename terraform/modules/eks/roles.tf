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
