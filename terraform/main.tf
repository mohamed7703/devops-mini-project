terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}
terraform {
  backend "local" {}
}
variable "kube_config_path" {
  description = "Path to the Kubernetes kubeconfig file"
  type        = string
  default     = "~/.kube/config"
}
variable "image_tag" {
  description = "Docker image tag to deploy"
  type        = string
  default     = "6"
}
provider "kubernetes" {
  config_path = var.kube_config_path
}

resource "kubernetes_deployment" "app" {
  metadata {
    name = "devops-mini-app"
    labels = {
      app = "devops-mini-app"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "devops-mini-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "devops-mini-app"
        }
      }

      spec {
        container {
          name              = "devops-mini-app"
          image             = "devops-mini-project:${var.image_tag}"
          image_pull_policy = "IfNotPresent"

          port {
            container_port = 5000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app" {
  metadata {
    name = "devops-mini-service"
  }

  spec {
    selector = {
      app = "devops-mini-app"
    }

    port {
      port        = 5000
      target_port = 5000
    }

    type = "ClusterIP"
  }
}
