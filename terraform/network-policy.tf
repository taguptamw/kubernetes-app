resource "kubernetes_network_policy" "mysql_allow_backend" {
    metadata {
      name      = "mysql-allow-backend-only"
      namespace = kubernetes_namespace.webapp.metadata[0].name
    }

    spec {
      pod_selector {
        match_labels = {
          app = "mysql"
        }
      }

      policy_types = ["Ingress"]

      ingress {
        from {
          pod_selector {
            match_labels = {
              app = "backend"
            }
          }
        }

        ports {
          port     = "3306"
          protocol = "TCP"
        }
      }
    }
}

resource "kubernetes_network_policy" "backend_allow_frontend" {
    metadata {
      name      = "backend-allow-frontend-only"
      namespace = kubernetes_namespace.webapp.metadata[0].name
    }

    spec {
      pod_selector {
        match_labels = {
          app = "backend"
        }
      }

      policy_types = ["Ingress"]

      ingress {
        from {
          pod_selector {
            match_labels = {
              app = "frontend"
            }
          }
        }

        ports {
          port     = "3000"
          protocol = "TCP"
        }
      }
    }
}