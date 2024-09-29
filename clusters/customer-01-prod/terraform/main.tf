module "main" {
  source       = "../../../modules/aks"
  cluster_name = "customer-01-prod"
  location     = "swedencentral"
}
