#resource "helm_release" "arc_operator" {
#  name             = "arc"
#  namespace        = "arc-systems"
#  create_namespace = true
#  repository       = "oci://ghcr.io/actions/actions-runner-controller-charts"
#  chart            = "gha-runner-scale-set-controller"
#  wait             = true
#
#  values = [file("${path.module}/charts/arc-operator/values.yaml")]
#}
