output "eks_cluster_role_name" {
  value = aws_iam_role.eks_cluster_role.name
}

output "eks_cluster_role_arn" {
  value = aws_eks_cluster.eks_cluster.arn
}
