resource "aws_ecr_repository" "app" {
  name                 = "${var.cluster_name}-app"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}



# Push Client Image to ECR
resource "terraform_data" "push_client_image" {
  depends_on = [aws_ecr_repository.app]

  provisioner "local-exec" {
    working_dir = "${path.module}/../../client"
    command     = <<EOT
      set -e
      aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${aws_ecr_repository.app.repository_url}
      docker build -t ${aws_ecr_repository.app.repository_url}:client-latest .
      docker push ${aws_ecr_repository.app.repository_url}:client-latest
    EOT
  }
}

# Push Server Image to ECR
resource "terraform_data" "push_server_image" {
  depends_on = [aws_ecr_repository.app]

  provisioner "local-exec" {
    working_dir = "${path.module}/../../server"
    command     = <<EOT
      set -e
      aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${aws_ecr_repository.app.repository_url}
      docker build -t ${aws_ecr_repository.app.repository_url}:server-latest .
      docker push ${aws_ecr_repository.app.repository_url}:server-latest
    EOT
  }
}
