resource "kubernetes_deployment" "backend" {
    metadata {
      name      = "backend"
      namespace = kubernetes_namespace.webapp.metadata[0].name

      labels = {
        app = "backend"
      }
    }

    depends_on = [kubernetes_deployment.mysql, kubernetes_service.mysql]

    spec {
      replicas = var.backend_replicas

      selector {
        match_labels = {
          app = "backend"
        }
      }

      template {
        metadata {
          labels = {
            app = "backend"
          }
        }

        spec {
          container {
            name              = "backend"
            image             = "${var.backend_image}:${var.backend_image_tag}"
            image_pull_policy = "Never"

            port {
              container_port = 3000
            }

            env {
              name = "DB_HOST"
              value_from {
                secret_key_ref {
                  name = kubernetes_secret.backend_secret.metadata[0].name
                  key  = "DB_HOST"
                }
              }
            }

            env {
              name = "DB_PORT"
              value_from {
                secret_key_ref {
                  name = kubernetes_secret.backend_secret.metadata[0].name
                  key  = "DB_PORT"
                }
              }
            }

            env {
              name = "DB_NAME"
              value_from {
                secret_key_ref {
                  name = kubernetes_secret.backend_secret.metadata[0].name
                  key  = "DB_NAME"
                }
              }
            }

            env {
              name = "DB_USER"
              value_from {
                secret_key_ref {
                  name = kubernetes_secret.backend_secret.metadata[0].name
                  key  = "DB_USER"
                }
              }
            }

            env {
              name = "DB_PASSWORD"
              value_from {
                secret_key_ref {
                  name = kubernetes_secret.backend_secret.metadata[0].name
                  key  = "DB_PASSWORD"
                }
              }
            }

            resources {
              requests = {
                cpu    = "100m"
                memory = "128Mi"
              }
              limits = {
                cpu    = "300m"
                memory = "256Mi"
              }
            }

            readiness_probe {
              http_get {
                path = "/api/health"
                port = 3000
              }
              initial_delay_seconds = 10
              period_seconds        = 5
            }

            liveness_probe {
              http_get {
                path = "/api/health"
                port = 3000
              }
              initial_delay_seconds = 15
              period_seconds        = 10
            }
          }
        }
      }
    }
}

resource "kubernetes_service" "backend" {
    metadata {
      name      = "backend-svc"
      namespace = kubernetes_namespace.webapp.metadata[0].name
    }

    spec {
      selector = {
        app = "backend"
      }

      port {
        port        = 3000
        target_port = 3000
      }

      type = "ClusterIP"
    }
}