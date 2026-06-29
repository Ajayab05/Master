variable "github_org" {
  description = "GitHub Organization or Username"
  type        = string
}

variable "github_repo" {
  description = "GitHub Repository"
  type        = string
}

variable "role_name" {
  description = "GitHub Actions IAM Role"

  type    = string
  default = "GitHubActionsTerraformRole"
}

variable "allowed_branches" {

  description = "GitHub branches allowed to assume the role"

  type = list(string)

  default = [
    "main"
  ]
}

variable "tags" {

  type    = map(string)
  default = {}

}
