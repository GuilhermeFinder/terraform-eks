#
# EKS Worker Nodes Resources
#  * IAM role allowing Kubernetes actions to access other AWS services
#  * EKS Node Group to launch worker nodes
#

resource "aws_iam_role" "prod_cluster_worker_nodes" {
  name = "aws-iam-role-prod-cluster-worker-nodes"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "prod_cluster_worker_nodes_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.prod_cluster_worker_nodes.name
}

resource "aws_iam_role_policy_attachment" "prod_cluster_worker_nodes_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.prod_cluster_worker_nodes.name
}

resource "aws_iam_role_policy_attachment" "prod_cluster_worker_nodes_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.prod_cluster_worker_nodes.name
}

resource "aws_eks_node_group" "prod_cluster_worker_nodes" {
  cluster_name    = var.prod_cluster_name
  node_group_name = var.prod_cluster_node_group_name
  node_role_arn   = aws_iam_role.prod_cluster_worker_nodes.arn
  subnet_ids      = var.prod_cluster_subnet_ids
  disk_size       = var.prod_cluster_node_group_disk_size
  instance_types  = var.prod_cluster_node_group_instance_types

  scaling_config {
    desired_size = var.prod_cluster_node_group_scaling_desired_size
    max_size     = var.prod_cluster_node_group_scaling_max_size
    min_size     = var.prod_cluster_node_group_scaling_min_size
  }

  depends_on = [
    aws_iam_role_policy_attachment.prod_cluster_worker_nodes_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.prod_cluster_worker_nodes_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.prod_cluster_worker_nodes_AmazonEC2ContainerRegistryReadOnly,
    aws_eks_cluster.prod_cluster,
  ]
}
