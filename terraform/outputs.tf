
output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "docdb_endpoint" {
  value = module.docdb.docdb_endpoint
}

output "node_security_group_id" {
  value = module.eks.node_security_group_id
}

output "node_role_name" {
  value = module.eks.node_role_name
}