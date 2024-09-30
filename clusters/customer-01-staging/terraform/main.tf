module "main" {
  source       = "../../../modules/aks"
  cluster_name = "customer-01-staging"
  location     = "swedencentral"
}
