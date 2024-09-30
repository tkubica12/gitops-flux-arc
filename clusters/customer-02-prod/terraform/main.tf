module "main" {
  source       = "../../../modules/aks"
  cluster_name = "customer-02-prod"
  location     = "swedencentral"
}
