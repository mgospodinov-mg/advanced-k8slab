resource "aws_internet_gateway" "k8slab_gw" {
  vpc_id = aws_vpc.k8slab_vpc.id

  tags = {
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}

resource "aws_route_table" "k8slab_rt" {
 vpc_id = aws_vpc.k8slab_vpc.id
 
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.k8slab_gw.id
 }
 
 tags = {
   Name = "k8slab Route Table"
   "kubernetes.io/cluster/kubernetes" = "owned"
 }
}

resource "aws_route_table_association" "k8slab_association" {
  subnet_id      = aws_subnet.k8slab_subnet.id
  route_table_id = aws_route_table.k8slab_rt.id
}