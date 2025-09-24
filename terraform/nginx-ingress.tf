resource "helm_release" "nginx_ingress" {
  name             = "nginx-ingress"
  namespace        = "nginx-ingress"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "nginx-ingress-controller"
  version          = "12.0.7"
  create_namespace = true

  values = [file("${path.module}/charts/nginx-ingress/values.yaml")]
}
