resource "helm_release" "openwebui" {
  name             = "open-webui"
  namespace        = "open-webui"
  repository       = "https://helm.openwebui.com"
  chart            = "open-webui"
  version          = "10.2.1"
  create_namespace = true

  values = [file("${path.module}/charts/open-webui/values.yaml")]
}
