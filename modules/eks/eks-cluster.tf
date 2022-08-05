#
# EKS Cluster Resources
#  * IAM Role to allow EKS service to manage other AWS services
#  * EC2 Security Group to allow networking traffic with EKS cluster
#  * EKS Cluster
#

resource "aws_iam_role" "prod_cluster" {
  name = "aws-iam-role-prod-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "prod_cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.prod_cluster.name
}

resource "aws_iam_role_policy_attachment" "prod_cluster_AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.prod_cluster.name
}

resource "aws_security_group" "prod_cluster" {
  name        = "aws-security-group-prod-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = var.prod_cluster_vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eks_cluster" "prod_cluster" {
  name     = var.prod_cluster_name
  role_arn = aws_iam_role.prod_cluster.arn

  vpc_config {
    security_group_ids = [aws_security_group.prod_cluster.id]
    subnet_ids         = var.prod_cluster_subnet_ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.prod_cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.prod_cluster_AmazonEKSVPCResourceController,
  ]
}
