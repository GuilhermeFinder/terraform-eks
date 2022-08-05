output "prod_cluster_id" {
  value = aws_eks_cluster.prod_cluster.id
}

output "prod_cluster_endpoint" {
  value = aws_eks_cluster.prod_cluster.endpoint
}

output "prod_cluster_certificate_authority_data" {
  value     = aws_eks_cluster.prod_cluster.certificate_authority[0].data
  sensitive = true
}