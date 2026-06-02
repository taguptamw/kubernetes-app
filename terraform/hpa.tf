resource "kubernetes_horizontal_pod_autoscaler_v2" "backend_hpa" {
    metadata {
      name      = "backend-hpa"
      namespace = kubernetes_namespace.webapp.metadata[0].name
    }

    spec {
      scale_target_ref {
        api_version = "apps/v1"
        kind        = "Deployment"
        name        = kubernetes_deployment.backend.metadata[0].name
      }

      min_replicas = 2
      max_replicas = 8

      metric {
        type = "Resource"
        resource {
          name = "cpu"
          target {
            type                = "Utilization"
            average_utilization = 50
          }
        }
      }

      metric {
        type = "Resource"
        resource {
          name = "memory"
          target {
            type                = "Utilization"
            average_utilization = 70
          }
        }
      }
    }
}

resource "kubernetes_horizontal_pod_autoscaler_v2" "frontend_hpa" {
    metadata {
      name      = "frontend-hpa"
      namespace = kubernetes_namespace.webapp.metadata[0].name
    }

    spec {
      scale_target_ref {
        api_version = "apps/v1"
        kind        = "Deployment"
        name        = kubernetes_deployment.frontend.metadata[0].name
      }

      min_replicas = 2
      max_replicas = 6

      metric {
        type = "Resource"
        resource {
          name = "cpu"
          target {
            type                = "Utilization"
            average_utilization = 60
          }
        }
      }
    }
}