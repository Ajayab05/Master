###############################################################
# Terraform Deployment Policy
###############################################################

resource "aws_iam_policy" "terraform_deployment" {

  name        = var.policy_name
  description = "Terraform Deployment Policy for GitHub Actions"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Sid    = "TerraformDeployment"

        Effect = "Allow"

        Action = [

          "ec2:*",
          "eks:*",
          "iam:*",
          "autoscaling:*",
          "elasticloadbalancing:*",
          "ecr:*",
          "logs:*",
          "cloudwatch:*",
          "events:*",

          "route53:*",
          "acm:*",

          "kms:*",

          "s3:*",

          "dynamodb:*",

          "sts:GetCallerIdentity",
          "sts:AssumeRole"

        ]

        Resource = "*"

      }

    ]

  })

  tags = var.tags

}

###############################################################
# Attach Policy to GitHub Role
###############################################################

resource "aws_iam_role_policy_attachment" "terraform_deployment" {

  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.terraform_deployment.arn

}
