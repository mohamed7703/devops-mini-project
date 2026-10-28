terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
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
          image             = "devops-mini-project:1.0"
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
