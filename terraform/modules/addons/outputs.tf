output "addons" {
  value = merge(
    {
      for k, v in aws_eks_addon.this : k => v.id
    },
    {
      aws-ebs-csi-driver = aws_eks_addon.ebs_csi.id
    }
  )
}
