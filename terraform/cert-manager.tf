resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true
  wait             = false
  version          = "v1.18.2"
  values           = [file("${path.module}/charts/cert-manager/values.yaml")]
}

resource "kubernetes_secret" "cloudflare_api_token" {
  metadata {
    name      = "cloudflare-api-token-secret"
    namespace = "cert-manager"
  }

  data = {
    api-token = var.cloudflare_api_token
  }
  type = "Opaque"
}

# Staging ClusterIssuer
resource "kubernetes_manifest" "letsencrypt_staging" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata   = { name = "letsencrypt-staging" }
    spec = {
      acme = {
        email               = var.acme_email
        server              = "https://acme-staging-v02.api.letsencrypt.org/directory"
        privateKeySecretRef = { name = "letsencrypt-staging" }
        solvers = [
          {
            dns01 = {
              cloudflare = {
                apiTokenSecretRef = { name = kubernetes_secret.cloudflare_api_token.metadata[0].name, key = "api-token" }
              }
            }
          }
        ]
      }
    }
  }

  depends_on = [kubernetes_secret.cloudflare_api_token]
}

# Production ClusterIssuer
resource "kubernetes_manifest" "letsencrypt_prod" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata   = { name = "letsencrypt-prod" }
    spec = {
      acme = {
        email               = var.acme_email
        server              = "https://acme-v02.api.letsencrypt.org/directory"
        privateKeySecretRef = { name = "letsencrypt-prod" }
        solvers = [
          {
            dns01 = {
              cloudflare = {
                apiTokenSecretRef = { name = kubernetes_secret.cloudflare_api_token.metadata[0].name, key = "api-token" }
              }
            }
          }
        ]
      }
    }
  }

  depends_on = [kubernetes_secret.cloudflare_api_token]
}