resource "aws_iam_role_policy" "eks_secrets_access" {
  name = "${var.cluster_name}-docdb-secrets-access"
  role = var.eks_node_role_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue"]
        Resource = aws_secretsmanager_secret.docdb_credentials.arn
      }
    ]
  })
}