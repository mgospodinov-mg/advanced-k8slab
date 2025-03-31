resource "tls_private_key" "generated_sshkey" {
  algorithm = "ED25519"
}

resource "local_sensitive_file" "k8slab_private_key"{
  filename = pathexpand("./sshkeys/k8slab")
  file_permission = "600"
  content = tls_private_key.generated_sshkey.private_key_openssh
}

resource "aws_key_pair" "k8slab_sshkey" {
  key_name   = "k8slab_sshkey"
  public_key = tls_private_key.generated_sshkey.public_key_openssh
}