resource "kubernetes_namespace" "webapp" {
    metadata {
      name = var.namespace

      labels = {
        app        = "k8s-webapp"
        managed-by = "terraform"
      }
    }
}