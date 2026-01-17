resource "kubernetes_namespace" "external_services" {
  metadata {
    name = "external-services"
  }
}


locals {
  services = var.external_services
}


resource "kubernetes_service" "ext_services" {
  for_each = local.services

  metadata {
    name      = "${each.key}-ext"
    namespace = "external-services"
  }

  spec {
    port {
      name        = "http"
      port        = each.value.port
      target_port = each.value.port
    }
  }
}


resource "kubernetes_endpoints" "ext_endpoints" {
  for_each = local.services

  metadata {
    name      = kubernetes_service.ext_services[each.key].metadata[0].name
    namespace = "external-services"
  }

  subset {
    address {
      ip = each.value.ip
    }

    port {
      name = "http"
      port = each.value.port
    }
  }
}

resource "kubernetes_ingress_v1" "ext_ingresses" {
  for_each = local.services

  metadata {
    name      = "${each.key}-ingress"
    namespace = "external-services"
    annotations = merge(
      {
        "cert-manager.io/cluster-issuer" = "letsencrypt-prod"
      },

      each.value.backend_https ? {
        "nginx.ingress.kubernetes.io/backend-protocol" = "HTTPS"
        "nginx.ingress.kubernetes.io/proxy-ssl-verify" = "off"
      } : {}
    )
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      host = each.value.domain
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.ext_services[each.key].metadata[0].name
              port {
                number = each.value.port
              }
            }
          }
        }
      }
    }

    tls {
      hosts       = [each.value.domain]
      secret_name = "${each.key}-tls-cert"
    }
  }
}
