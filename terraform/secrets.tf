resource "kubernetes_secret" "mysql_secret" {
    metadata {
      name      = "mysql-secret"
      namespace = kubernetes_namespace.webapp.metadata[0].name
    }

    data = {
      MYSQL_ROOT_PASSWORD = var.mysql_root_password
      MYSQL_DATABASE      = var.mysql_database
      MYSQL_USER          = var.mysql_user
      MYSQL_PASSWORD      = var.mysql_password
    }

    type = "Opaque"
}

resource "kubernetes_secret" "backend_secret" {
    metadata {
      name      = "backend-secret"
      namespace = kubernetes_namespace.webapp.metadata[0].name
    }

    data = {
      DB_HOST     = "mysql-svc"
      DB_PORT     = "3306"
      DB_NAME     = var.mysql_database
      DB_USER     = var.mysql_user
      DB_PASSWORD = var.mysql_password
    }

    type = "Opaque"
}