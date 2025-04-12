data "aws_ami" "ubuntu2404" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "master" {
  ami           = data.aws_ami.ubuntu2404.id
  instance_type = var.instance_type
  subnet_id =  aws_subnet.k8slab_subnet.id
  vpc_security_group_ids = [aws_security_group.k8slab_security.id]
  key_name = aws_key_pair.k8slab_sshkey.key_name
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.k8slab-master-instance-profile.name

  root_block_device {
    volume_size = 20
  }  
  
  tags = {
    Name = "Master node"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}

resource "aws_instance" "worker" {
  count = var.number_workers
  ami           = data.aws_ami.ubuntu2404.id
  instance_type = var.instance_type
  subnet_id = aws_subnet.k8slab_subnet.id
  vpc_security_group_ids = [aws_security_group.k8slab_security.id]
  key_name = aws_key_pair.k8slab_sshkey.key_name
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.k8slab-worker-instance-profile.name

  root_block_device {
    volume_size = 20
  }  

  tags = {
    Name = "Worker${count.index + 1} node"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}

resource "local_file" "ansible_inventory" {
  content = templatefile("./templates/inventory.tftpl",
    {
      master_ip = aws_instance.master.public_ip
      worker_ip = aws_instance.worker.*.public_ip
    }
  )
  filename = "../ansible_advk8slab/inventory.ini"
}
