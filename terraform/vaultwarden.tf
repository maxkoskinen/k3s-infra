resource "kubernetes_namespace_v1" "vaultwarden_ns" {
  metadata {
    name = "vaultwarden"
  }
}

resource "kubernetes_secret" "vaultwarden_secret" {
  metadata {
    name      = "vaultwarden-secret"
    namespace = "vaultwarden"
  }

  data = {
    SMTP_USERNAME = var.mail_smtp_username
    SMTP_PASSWORD = var.mail_smtp_password
    ADMIN_TOKEN = var.vaultwarden_admin_token
  }
  type = "Opaque"

  depends_on = [kubernetes_namespace_v1.vaultwarden_ns]
}

resource "helm_release" "vaultwarden" {
  name             = "vaultwarden-release"
  repository       = "https://guerzon.github.io/vaultwarden"
  chart            = "vaultwarden"
  namespace        = "vaultwarden"
  create_namespace = true
  wait             = true
  version          = "0.34.3"
  values           = [file("${path.module}/charts/vaultwarden/values.yaml")]

  depends_on = [kubernetes_secret.vaultwarden_secret]
}