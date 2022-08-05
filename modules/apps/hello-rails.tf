resource "kubernetes_namespace" "hello_rails" {
  metadata {
    name = "hello-rails"
  }
}

resource "kubernetes_service" "hello_rails" {
  metadata {
    name      = "hello-rails"
    namespace = kubernetes_namespace.hello_rails.metadata.0.name
  }
  spec {
    selector = {
      app = "hello-rails"
    }
    type = "LoadBalancer"
    port {
      port        = 3000
      target_port = 3000
    }
  }
}

resource "kubernetes_deployment" "hello_rails" {
  metadata {
    name      = "hello-rails"
    namespace = kubernetes_namespace.hello_rails.metadata.0.name
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "hello-rails"
      }
    }
    template {
      metadata {
        labels = {
          app = "hello-rails"
        }
      }
      spec {
        container {
          image = "guilhermefinder/hello-rails:4b888d858f253f67b804c6af0748cfb67cadf00e"
          name  = "hello-rails-container"
          env {
            name  = "HOSTNAME"
            value = kubernetes_service.hello_rails.status[0].load_balancer[0].ingress[0].hostname
          }
          port {
            container_port = 3000
          }
        }
      }
    }
  }
}