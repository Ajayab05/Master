variable "github_owner" {
  description = "GitHub organization or username"
  type        = string
}

variable "github_repository" {
  description = "GitHub repository name"
  type        = string
}

variable "github_branches" {
  description = "Branches allowed to assume the GitHub Actions IAM role"

  type = list(string)

  default = [
    "main"
  ]
}

variable "role_name" {
  description = "GitHub Actions IAM Role"

  type    = string
  default = "GitHubActionsTerraformRole"
}

variable "policy_name" {
  description = "Terraform deployment IAM Policy"

  type    = string
  default = "TerraformDeploymentPolicy"
}

variable "tags" {
  description = "Tags applied to all resources"

  type = map(string)

  default = {}
}
