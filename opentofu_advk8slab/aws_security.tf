resource "aws_security_group" "k8slab_security" {
  name        = "allow-all"
  vpc_id      = aws_vpc.k8slab_vpc.id

  tags = {
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_all_port" {
  security_group_id = aws_security_group.k8slab_security.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  tags = {
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.k8slab_security.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 

  tags = {
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}
