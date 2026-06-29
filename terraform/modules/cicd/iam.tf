###############################################################
# GitHub Actions IAM Role
###############################################################

resource "aws_iam_role" "github_actions" {

  name = var.role_name

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Sid    = "GitHubActionsAssumeRole"

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

  max_session_duration = 3600

  tags = var.tags
}
