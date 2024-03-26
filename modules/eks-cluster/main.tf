data "aws_iam_policy_document" "eks_cluster_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name               = "${var.project_name}-eks_cluster_role-${terraform.workspace}"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_policy.json
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "eks-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster_role.name
}




#create EKS Cluster eks_cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.project_name}-eks_cluster-${terraform.workspace}"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access = true
    subnet_ids = [var.privsn_app_az1_id, var.privsn_app_az2_id]
  }
}

#create IAM Role for nodegroup
resource "aws_iam_role" "nodegroup-role" {
  name = "${var.project_name}-nodegroup-role-${terraform.workspace}"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "nodegroup-role-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodegroup-role.name
}

resource "aws_iam_role_policy_attachment" "nodegroup-role-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodegroup-role.name
}

resource "aws_iam_role_policy_attachment" "nodegroup-role-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodegroup-role.name
}

#create nodegroup

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.project_name}-node_group-${terraform.workspace}"
  node_role_arn   = aws_iam_role.nodegroup-role.arn
  subnet_ids      = [
    var.pubsn_web_az1_id,
    var.pubsn_web_az1_id,
    var.privsn_app_az1_id,
    var.privsn_app_az2_id,
    ]

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  update_config {
    max_unavailable = var.max_unavailable
  }
  instance_types = [var.instance_types]

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.nodegroup-role-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodegroup-role-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodegroup-role-AmazonEC2ContainerRegistryReadOnly,
  ]
}

