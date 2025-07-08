resource "aws_iam_policy" "master-policy" {
  name        = "k8slab-iam-master-policy"
  description = "iam-master-policy"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeTags",
          "ec2:DescribeInstances",
          "ec2:DescribeRegions",
          "ec2:DescribeRouteTables",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeVolumes",
          "ec2:DescribeAvailabilityZones",
          "ec2:CreateSecurityGroup",
          "ec2:CreateTags",
          "ec2:CreateVolume",
          "ec2:ModifyInstanceAttribute",
          "ec2:ModifyVolume",
          "ec2:AttachVolume",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:CreateRoute",
          "ec2:DeleteRoute",
          "ec2:DeleteSecurityGroup",
          "ec2:DeleteVolume",
          "ec2:DetachVolume",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:DescribeVpcs",
          "ec2:DescribeInstanceTopology",
          "elasticloadbalancing:AddTags",
          "elasticloadbalancing:AttachLoadBalancerToSubnets",
          "elasticloadbalancing:ApplySecurityGroupsToLoadBalancer",
          "elasticloadbalancing:CreateLoadBalancer",
          "elasticloadbalancing:CreateLoadBalancerPolicy",
          "elasticloadbalancing:CreateLoadBalancerListeners",
          "elasticloadbalancing:ConfigureHealthCheck",
          "elasticloadbalancing:DeleteLoadBalancer",
          "elasticloadbalancing:DeleteLoadBalancerListeners",
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeLoadBalancerAttributes",
          "elasticloadbalancing:DetachLoadBalancerFromSubnets",
          "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
          "elasticloadbalancing:ModifyLoadBalancerAttributes",
          "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
          "elasticloadbalancing:SetLoadBalancerPoliciesForBackendServer",
          "elasticloadbalancing:AddTags",
          "elasticloadbalancing:CreateListener",
          "elasticloadbalancing:CreateTargetGroup",
          "elasticloadbalancing:DeleteListener",
          "elasticloadbalancing:DeleteTargetGroup",
          "elasticloadbalancing:DescribeListeners",
          "elasticloadbalancing:DescribeLoadBalancerPolicies",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:DescribeTargetHealth",
          "elasticloadbalancing:ModifyListener",
          "elasticloadbalancing:ModifyTargetGroup",
          "elasticloadbalancing:RegisterTargets",
          "elasticloadbalancing:DeregisterTargets",
          "elasticloadbalancing:SetLoadBalancerPoliciesOfListener",
          "iam:CreateServiceLinkedRole",
          "kms:DescribeKey"
        ],
        "Resource": [
          "*"
        ]
      }
  ]
  })
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

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ec2:DescribeInstances",
          "ec2:DescribeRegions",
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:BatchGetImage"
        ],
        "Resource": "*"
      }
  ]
  })
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

  policy = file("./policy/csi-policy.json")
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
