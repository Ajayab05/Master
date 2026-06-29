module "vpc" {

  source = "../../modules/vpc"

  project_name = var.project_name

  environment = var.environment

  vpc_cidr = "10.0.0.0/16"

  availability_zones = [
    "us-east-1a",
    "us-east-1b"
  ]

  public_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  private_subnets = [
    "10.0.11.0/24",
    "10.0.12.0/24"
  ]

}




module "eks" {
  source = "../../modules/eks"

  project_name    = var.project_name
  environment     = var.environment
  cluster_version = var.cluster_version

  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets

}


module "ebs_csi_irsa" {
  source = "../../modules/pod-identity"

  cluster_name         = module.eks.cluster_name
  namespace            = "kube-system"
  service_account_name = "ebs-csi-controller-sa"

  role_name = "AmazonEKS_EBS_CSI_Driver"

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"

  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = module.eks.oidc_provider
}



module "eks_addons" {

  source = "../../modules/addons"

  cluster_name = module.eks.cluster_name

  cluster_ready = module.eks

  ebs_csi_role_arn = module.ebs_csi_irsa.role_arn

  depends_on = [
    module.ebs_csi_irsa
  ]
}
