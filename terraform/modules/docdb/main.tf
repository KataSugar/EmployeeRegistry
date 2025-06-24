resource "random_password" "docdb_password" {
  length           = 16
  special          = true
  override_special = "!#$"
}

resource "random_string" "secret_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_secretsmanager_secret" "docdb_credentials" {
  name        = "${var.cluster_name}-docdb-${random_string.secret_suffix.result}"
  description = "Credentials for DocumentDB cluster"
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_secretsmanager_secret_version" "docdb_credentials_version" {
  secret_id = aws_secretsmanager_secret.docdb_credentials.id
  secret_string = jsonencode({
    username = var.master_username
    password = random_password.docdb_password.result
  })
}

resource "aws_security_group" "docdb_sg" {
  vpc_id = var.vpc_id
  name   = "${var.cluster_name}-docdb-sg"

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    security_groups = var.allowed_security_groups
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-docdb-sg"
  }
}

resource "aws_docdb_subnet_group" "docdb_subnet_group" {
  name       = "${var.cluster_name}-docdb-subnet-group"
  subnet_ids = [var.subnet_a_id, var.subnet_b_id]
  tags = {
    Name = "${var.cluster_name}-docdb-subnet-group"
  }
}

resource "aws_docdb_cluster" "default" {
  cluster_identifier      = "${var.cluster_name}-docdb"
  engine                  = "docdb"
  engine_version          = "5.0.0"
  master_username         = var.master_username
  master_password         = random_password.docdb_password.result
  db_subnet_group_name    = aws_docdb_subnet_group.docdb_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.docdb_sg.id]
   skip_final_snapshot     = false
  final_snapshot_identifier = "${var.cluster_name}-docdb-final"
  apply_immediately       = true
  storage_encrypted       = true

  lifecycle {
    prevent_destroy = false
  }
  tags = {
    Name = "${var.cluster_name}-docdb"
  }
}

resource "aws_docdb_cluster_instance" "default" {
  identifier              = "${var.cluster_name}-docdb-instance"
  cluster_identifier      = aws_docdb_cluster.default.id
  instance_class          = "db.t3.medium"
  engine                  = "docdb"

  tags = {
    Name = "${var.cluster_name}-docdb-instance"
  }
}


#data "aws_secretsmanager_secret_version" "docdb_credentials" {
#  secret_id = aws_secretsmanager_secret.docdb_credentials.id
#}