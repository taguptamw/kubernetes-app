resource "kubernetes_persistent_volume_claim" "mysql_pvc" {
    metadata {
      name      = "mysql-pvc"
      namespace = kubernetes_namespace.webapp.metadata[0].name
    }

    spec {
      access_modes = ["ReadWriteOnce"]

      resources {
        requests = {
          storage = "1Gi"
        }
      }
    }
}

resource "kubernetes_deployment" "mysql" {
    metadata {
      name      = "mysql"
      namespace = kubernetes_namespace.webapp.metadata[0].name

      labels = {
        app = "mysql"
      }
    }

    spec {
      replicas = 1

      selector {
        match_labels = {
          app = "mysql"
        }
      }

      template {
        metadata {
          labels = {
            app = "mysql"
          }
        }

        spec {
          container {
            name  = "mysql"
            image = "mysql:8.0"

            port {
              container_port = 3306
            }

            env {
              name = "MYSQL_ROOT_PASSWORD"
              value_from {
                secret_key_ref {
                  name = kubernetes_secret.mysql_secret.metadata[0].name
                  key  = "MYSQL_ROOT_PASSWORD"
                }
              }
            }

            env {
              name = "MYSQL_DATABASE"
              value_from {
                secret_key_ref {
                  name = kubernetes_secret.mysql_secret.metadata[0].name
                  key  = "MYSQL_DATABASE"
                }
              }
            }

            env {
              name = "MYSQL_USER"
              value_from {
                secret_key_ref {
                  name = kubernetes_secret.mysql_secret.metadata[0].name
                  key  = "MYSQL_USER"
                }
              }
            }

            env {
              name = "MYSQL_PASSWORD"
              value_from {
                secret_key_ref {
                  name = kubernetes_secret.mysql_secret.metadata[0].name
                  key  = "MYSQL_PASSWORD"
                }
              }
            }

            volume_mount {
              name       = "mysql-data"
              mount_path = "/var/lib/mysql"
            }

            resources {
              requests = {
                cpu    = "100m"
                memory = "256Mi"
              }
              limits = {
                cpu    = "500m"
                memory = "512Mi"
              }
            }

            liveness_probe {
              exec {
                command = ["mysqladmin", "ping", "-h", "localhost", "-u", "root", "-prootpass123"]
              }
              initial_delay_seconds = 30
              period_seconds        = 10
            }

            readiness_probe {
              exec {
                command = ["mysqladmin", "ping", "-h", "localhost", "-u", "root", "-prootpass123"]
              }
              initial_delay_seconds = 20
              period_seconds        = 10
            }
          }

          volume {
            name = "mysql-data"

            persistent_volume_claim {
              claim_name = kubernetes_persistent_volume_claim.mysql_pvc.metadata[0].name
            }
          }
        }
      }
    }
}

resource "kubernetes_service" "mysql" {
    metadata {
      name      = "mysql-svc"
      namespace = kubernetes_namespace.webapp.metadata[0].name
    }

    spec {
      selector = {
        app = "mysql"
      }

      port {
        port        = 3306
        target_port = 3306
      }

      type = "ClusterIP"
    }
}