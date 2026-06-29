resource "helm_release" "this" {

  name       = "aws-load-balancer-controller"

  namespace  = var.namespace

  repository = "https://aws.github.io/eks-charts"

  chart = "aws-load-balancer-controller"

  version = var.chart_version

  atomic = false

  wait = true

  timeout = 300

  values = [

    yamlencode({

      clusterName = var.cluster_name

      region = var.region

      vpcId = var.vpc_id

      serviceAccount = {

        create = false

        name = "aws-load-balancer-controller"

      }

    })

  ]

}
