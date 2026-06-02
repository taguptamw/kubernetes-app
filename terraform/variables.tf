variable "namespace" {
    description = "Kubernetes namespace"
    type        = string
    default     = "webapp"
}

variable "mysql_root_password" {
    description = "MySQL root password"
    type        = string
    sensitive   = true
}

variable "mysql_database" {
    description = "MySQL database name"
    type        = string
    default     = "webapp"
}

variable "mysql_user" {
    description = "MySQL application user"
    type        = string
    default     = "appuser"
}

variable "mysql_password" {
    description = "MySQL application user password"
    type        = string
    sensitive   = true
}

variable "backend_image" {
    description = "Backend Docker image"
    type        = string
    default     = "k8s-backend"
}

variable "backend_image_tag" {
    description = "Backend Docker image tag"
    type        = string
    default     = "2.0"
}

variable "frontend_image" {
    description = "Frontend Docker image"
    type        = string
    default     = "k8s-frontend"
}

variable "frontend_image_tag" {
    description = "Frontend Docker image tag"
    type        = string
    default     = "1.0"
}

variable "backend_replicas" {
    description = "Number of backend replicas"
    type        = number
    default     = 2
}

variable "frontend_replicas" {
    description = "Number of frontend replicas"
    type        = number
    default     = 2
}