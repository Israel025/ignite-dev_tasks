#===========TERRAFORM HELM PROVIDER==========
#============================================
# helm provider configuration
provider "helm" {
  kubernetes {
    config_path = "./kube_config/clust_kubeconfig.yaml"
  }
}
#============================================


#===============HELM RESOURCE===============
#============================================
resource "helm_release" "example" {
  name       = "my-kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"

  set {
    name  = "cluster.enabled"
    value = "true"
  }

  set {
    name  = "metrics.enabled"
    value = "true"
  }
}
#============================================