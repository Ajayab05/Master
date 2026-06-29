data "tls_certificate" "github" {

  url = "https://token.actions.githubusercontent.com"

}

locals {

  github_subjects = [

    for branch in var.allowed_branches :

    "repo:${var.github_org}/${var.github_repo}:ref:refs/heads/${branch}"

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

resource "aws_iam_role" "github_actions" {

  name = var.role_name

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Action = "sts:AssumeRoleWithWebIdentity"

        Principal = {

          Federated = aws_iam_openid_connect_provider.github.arn

        }

        Condition = {

          StringEquals = {

            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"

          }

          StringLike = {

            "token.actions.githubusercontent.com:sub" = local.github_subjects

          }

        }

      }

    ]

  })

  tags = var.tags

}

#
# LAB ONLY
#
# Replace with least privilege policy later.
#

resource "aws_iam_role_policy_attachment" "administrator" {

  role = aws_iam_role.github_actions.name

  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"

}
