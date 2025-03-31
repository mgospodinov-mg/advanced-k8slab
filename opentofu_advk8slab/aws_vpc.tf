resource "aws_vpc" "k8slab_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Name = "k8slab_vpc"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}