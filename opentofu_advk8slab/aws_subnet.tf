# Retrieve Availability Zones within a Specified Region
data "aws_availability_zones" "region_azones" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

data "aws_ec2_instance_type_offerings" "k8s_instance_type" {
  for_each = toset(data.aws_availability_zones.region_azones.names)
  filter {
    name   = "instance-type"
    values = [var.instance_type]
  }
  filter {
    name   = "location"
    values = [each.key]
  }
  location_type = "availability-zone"
}

locals {
  azones_instances = keys({
    for az, details in data.aws_ec2_instance_type_offerings.k8s_instance_type: 
    az => details.instance_types if length(details.instance_types) != 0 })
}

resource "random_shuffle" "az" {
  input        = local.azones_instances
  result_count = 1
}

resource "aws_subnet" "k8slab_subnet" {
  cidr_block        = "10.0.1.0/24"
  vpc_id            = aws_vpc.k8slab_vpc.id
  availability_zone = random_shuffle.az.result[0]
  map_public_ip_on_launch = true

  tags = {
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}