terraform {
  backend "s3" {
    bucket         = "eks-upgrade-demo-tfstate-076124125794"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "eks-upgrade-demo-terraform-lock"
    encrypt        = true
  }
}
