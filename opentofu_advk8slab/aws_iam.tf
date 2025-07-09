resource "aws_iam_policy" "master-policy" {
  name        = "k8slab-iam-master-policy"
  description = "iam-master-policy"

  policy = file("iam-policies/master-policy.json")
}

resource "aws_iam_role" "k8slab-master-role" {
  name = "k8slab-master-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [ 
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "k8slab-master-role-attachment" {
  role = aws_iam_role.k8slab-master-role.name
  policy_arn = aws_iam_policy.master-policy.arn  
}

resource "aws_iam_instance_profile" "k8slab-master-instance-profile" {
  name = "k8slab-master-instance-profile"
  role = aws_iam_role.k8slab-master-role.name
}

resource "aws_iam_policy" "worker-policy" {
  name        = "k8slab-iam-worker-policy"
  description = "iam-worker-policy"

  policy = file("iam-policies/worker-policy.json")
}

resource "aws_iam_role" "k8slab-worker-role" {
  name = "k8slab-worker-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [ 
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "k8slab-worker-role-attachment" {
  role = aws_iam_role.k8slab-worker-role.name
  policy_arn = aws_iam_policy.worker-policy.arn  
}

resource "aws_iam_instance_profile" "k8slab-worker-instance-profile" {
  name = "k8slab-worker-instance-profile"
  role = aws_iam_role.k8slab-worker-role.name
}

resource "aws_iam_policy" "csi-policy" {
  name        = "k8slab-iam-csi-policy"
  description = "iam-csi-policy"

  policy = file("iam-policies/csi-policy.json")
}

resource "aws_iam_role" "k8slab-csi-role" {
  name = "k8slab-csi-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [ 
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "k8slab-csi-role-attachment" {
  role = aws_iam_role.k8slab-csi-role.name
  policy_arn = aws_iam_policy.csi-policy.arn  
}

resource "aws_iam_instance_profile" "k8slab-csi-profile" {
  name = "k8slab-csi-profile"
  role = aws_iam_role.k8slab-csi-role.name
}
