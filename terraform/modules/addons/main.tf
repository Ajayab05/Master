locals {
  addons = {
    vpc-cni = {
      resolve_conflicts_on_create = "OVERWRITE"
    }

    coredns = {
      resolve_conflicts_on_create = "OVERWRITE"
    }

    kube-proxy = {
      resolve_conflicts_on_create = "OVERWRITE"
    }

    eks-pod-identity-agent = {
      resolve_conflicts_on_create = "OVERWRITE"
    }
  }
}

# Standard AWS managed add-ons
resource "aws_eks_addon" "this" {

  for_each = local.addons

  cluster_name = var.cluster_name
  addon_name   = each.key

  resolve_conflicts_on_create = each.value.resolve_conflicts_on_create

  depends_on = [
    var.cluster_ready
  ]

  timeouts {
    create = "30m"
    delete = "30m"
  }
}

# EBS CSI Driver (separate because it needs IAM)
resource "aws_eks_addon" "ebs_csi" {

  cluster_name = var.cluster_name
  addon_name   = "aws-ebs-csi-driver"

  service_account_role_arn = var.ebs_csi_role_arn

  resolve_conflicts_on_create = "OVERWRITE"

  depends_on = [
    var.cluster_ready
  ]

  timeouts {
    create = "30m"
    delete = "30m"
  }
}
