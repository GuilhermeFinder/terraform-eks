output "prod_cluster_vpc_id" {
  value = aws_vpc.prod_cluster.id
}

output "prod_cluster_subnet_ids" {
  value = aws_subnet.prod_cluster.*.id
}