module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  # -----------------------------------------------------------------------------
  # Cluster
  # -----------------------------------------------------------------------------

  name               = "${var.project_name}-${var.environment}"
  kubernetes_version = var.cluster_version

  authentication_mode = "API_AND_CONFIG_MAP"
  enable_cluster_creator_admin_permissions = true

  endpoint_public_access  = true
  endpoint_private_access = true

  enabled_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  # -----------------------------------------------------------------------------
  # Networking
  # -----------------------------------------------------------------------------

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  # -----------------------------------------------------------------------------
  # IAM
  # -----------------------------------------------------------------------------

  enable_irsa = true


  # -----------------------------------------------------------------------------
  # Managed Node Group
  # -----------------------------------------------------------------------------

  eks_managed_node_groups = {

    default = {

      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"

      min_size     = 2
      desired_size = 2
      max_size     = 3

      update_config = {
        max_unavailable_percentage = 33
      }

      tags = {
        Name = "default"
      }

    }

  }

  # -----------------------------------------------------------------------------
  # Tags
  # -----------------------------------------------------------------------------

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
