variable "aws_region" {
  default = "sa-east-1"
  type    = string
}

variable "prod_cluster_name" {
  default = "demo"
  type    = string
}

variable "prod_cluster_node_group_name" {
  default = "demo"
  type    = string
}

variable "prod_cluster_node_group_disk_size" {
  default = 10
  type    = number
}

variable "prod_cluster_node_group_instance_types" {
  default = ["t3.micro"]
  type    = list(any)
}

variable "prod_cluster_node_group_scaling_desired_size" {
  default = 1
  type    = number
}

variable "prod_cluster_node_group_scaling_max_size" {
  default = 1
  type    = number
}

variable "prod_cluster_node_group_scaling_min_size" {
  default = 1
  type    = number
}