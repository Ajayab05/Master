###############################################################
# GitHub OIDC Provider
###############################################################

data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com"
}

locals {

  github_subjects = [

    for branch in var.github_branches :

    "repo:${var.github_owner}/${var.github_repository}:ref:refs/heads/${branch}"

  ]

}

resource "aws_iam_openid_connect_provider" "github" {

  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    data.tls_certificate.github.certificates[0].sha1_fingerprint
  ]

  tags = var.tags

}
