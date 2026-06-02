output "namespace" {
    value = kubernetes_namespace.webapp.metadata[0].name
}

output "frontend_service" {
    value = "NodePort: ${kubernetes_service.frontend.spec[0].port[0].node_port}"
}

output "backend_service" {
    value = kubernetes_service.backend.metadata[0].name
}

output "mysql_service" {
    value = kubernetes_service.mysql.metadata[0].name
}

output "access_command" {
    value = "kubectl port-forward -n webapp svc/frontend-svc 8080:80 --address 0.0.0.0"
}