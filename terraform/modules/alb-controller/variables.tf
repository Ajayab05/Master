variable "cluster_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "region" {
  type = string
}

variable "namespace" {
  type    = string
  default = "kube-system"
}

variable "chart_version" {
  type    = string
  default = "3.4.0"
}
