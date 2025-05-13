#EKS cluster role
resource "aws_iam_role" "eks_cluster_role" {
  name               = "${var.cluster_name}-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role_policy.json

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-cluster-role"
    },
  )
}