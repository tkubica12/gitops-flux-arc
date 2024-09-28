variable "location" {
  type        = string
  default     = "swedencentral"
  description = <<EOF
Azure region for resources.

Examples: swedencentral, westeurope, northeurope, germanywestcentral.
EOF
}

variable "cluster_name" {
  type        = string
  description = <<EOF
Name of the AKS cluster which is also used for Git path for deployment of apps.
EOF
}

