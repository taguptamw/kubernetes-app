resource "kubernetes_deployment" "frontend" {
    metadata {
      name      = "frontend"
      namespace = kubernetes_namespace.webapp.metadata[0].name

      labels = {
        app = "frontend"
      }
    }

    depends_on = [kubernetes_deployment.backend, kubernetes_service.backend]

    spec {
      replicas = var.frontend_replicas

      selector {
        match_labels = {
          app = "frontend"
        }
      }

      template {
        metadata {
          labels = {
            app = "frontend"
          }
        }

        spec {
          container {
            name              = "frontend"
            image             = "${var.frontend_image}:${var.frontend_image_tag}"
            image_pull_policy = "Never"

            port {
              container_port = 80
            }

            resources {
              requests = {
                cpu    = "50m"
                memory = "64Mi"
              }
              limits = {
                cpu    = "200m"
                memory = "128Mi"
              }
            }

            readiness_probe {
              http_get {
                path = "/"
                port = 80
              }
              initial_delay_seconds = 5
              period_seconds        = 5
            }

            liveness_probe {
              http_get {
                path = "/"
                port = 80
              }
              initial_delay_seconds = 5
              period_seconds        = 10
            }
          }
        }
      }
    }
}

resource "kubernetes_service" "frontend" {
    metadata {
      name      = "frontend-svc"
      namespace = kubernetes_namespace.webapp.metadata[0].name
    }

    spec {
      selector = {
        app = "frontend"
      }

      port {
        port        = 80
        target_port = 80
        node_port   = 30080
      }

      type = "NodePort"
    }
}