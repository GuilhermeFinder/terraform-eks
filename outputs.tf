output "prod_cluster_id" {
  value = module.eks.prod_cluster_id
}

output "prod_cluster_endpoint" {
  value = module.eks.prod_cluster_endpoint
}

output "prod_cluster_certificate_authority_data" {
  value     = module.eks.prod_cluster_certificate_authority_data
  sensitive = true
}