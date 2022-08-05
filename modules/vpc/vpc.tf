#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#

data "aws_availability_zones" "available" {}

resource "aws_vpc" "prod_cluster" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "prod_cluster" {
  count = 2

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.prod_cluster.id
}

resource "aws_internet_gateway" "prod_cluster" {
  vpc_id = aws_vpc.prod_cluster.id
}

resource "aws_route_table" "prod_cluster" {
  vpc_id = aws_vpc.prod_cluster.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prod_cluster.id
  }
}

resource "aws_route_table_association" "prod_cluster" {
  count = 2

  subnet_id      = aws_subnet.prod_cluster.*.id[count.index]
  route_table_id = aws_route_table.prod_cluster.id
}
