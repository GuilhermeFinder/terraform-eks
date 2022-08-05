terraform {
  required_version = "=1.2.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "=4.24.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "=2.12.0"
    }
  }
  backend "s3" {
    bucket  = "tfstate-click-bucket"
    key     = "prod/terraform.tfstate"
    region  = "sa-east-1"
    encrypt = true
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source            = "./modules/vpc"
  prod_cluster_name = var.prod_cluster_name
}

module "eks" {
  source                                       = "./modules/eks"
  aws_region                                   = var.aws_region
  prod_cluster_name                            = var.prod_cluster_name
  prod_cluster_node_group_name                 = var.prod_cluster_node_group_name
  prod_cluster_node_group_disk_size            = var.prod_cluster_node_group_disk_size
  prod_cluster_node_group_instance_types       = var.prod_cluster_node_group_instance_types
  prod_cluster_node_group_scaling_desired_size = var.prod_cluster_node_group_scaling_desired_size
  prod_cluster_node_group_scaling_max_size     = var.prod_cluster_node_group_scaling_max_size
  prod_cluster_node_group_scaling_min_size     = var.prod_cluster_node_group_scaling_min_size
  prod_cluster_vpc_id                          = module.vpc.prod_cluster_vpc_id
  prod_cluster_subnet_ids                      = module.vpc.prod_cluster_subnet_ids
}

module "s3" {
  source = "./modules/s3"
}

data "aws_eks_cluster_auth" "prod_cluster" {
  name = module.eks.prod_cluster_id
}

provider "kubernetes" {
  host                   = module.eks.prod_cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.prod_cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.prod_cluster.token
}

module "apps" {
  source = "./modules/apps"
}