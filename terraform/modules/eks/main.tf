resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [var.subnet_a_id, var.subnet_b_id]

  }
  depends_on = [aws_iam_role_policy_attachment.cluster_policy_attachment]
}

resource "aws_eks_node_group" "backend" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "backend-nodes"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = var.public_subnet_ids
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
  instance_types = ["t3.medium"]
  labels = {
    "node-type" = "backend-nodes"
  }
  tags = {
    Name = "backend-nodes"
  }
  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_policy,
    aws_iam_role_policy_attachment.eks_vpc_resource_controller,
    aws_iam_role_policy_attachment.ecr_read_policy
  ]
}

resource "aws_eks_node_group" "frontend" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "frontend-nodes"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = var.public_subnet_ids
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
  instance_types = ["t3.medium"]
  labels = {
    "node-type" = "frontend-nodes"
  }
  tags = {
    Name = "frontend-nodes"
  }
  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_policy,
    aws_iam_role_policy_attachment.eks_vpc_resource_controller,
    aws_iam_role_policy_attachment.ecr_read_policy
  ]
}

resource "terraform_data" "configure_kubectl" {
  count      = var.configure_kubectl ? 1 : 0
  depends_on = [aws_eks_cluster.eks]
  
  provisioner "local-exec" {
    command = <<EOT
      aws eks update-kubeconfig --region ${var.aws_region} --name ${aws_eks_cluster.eks.name}
    EOT
  }
}

