#=========KUBECTL TERRAFORM PROVIDER=========
#============================================
# kubectl provider configuration
provider "kubectl" {
  config_path = "./kube_config/clust_kubeconfig.yaml"
}
#============================================


#======KUBECTL RESOURCES & DATA SOURCES======

#============KUBECTL DATA SOURCES============
# kubectl application k8s files path data
data "kubectl_path_documents" "app_manifests" {
  pattern = "./k8s_nodeApp/*.yaml"
}
#============================================

#==============KUBECTL RESOURCE==============
# kubectl resource configuration
resource "kubectl_manifest" "hello_app" {
  for_each  = toset(data.kubectl_path_documents.app_manifests.documents)
  yaml_body = each.value
}
#============================================