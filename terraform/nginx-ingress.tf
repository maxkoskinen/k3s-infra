resource "helm_release" "nginx_ingress" {
  name             = "ingress-nginx"
  namespace        = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = "4.14.1"
  create_namespace = true

  values = [file("${path.module}/charts/ingress-nginx/values.yaml")]
}
