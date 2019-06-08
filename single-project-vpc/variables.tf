

# ID of the organization where the Project is to be created
variable "organization_id" {
  description = "The organization id for your GCP organization"
}

# Path to credentials file for service account to be used for this deployment
variable "credentials_file_path" {
  description = "Path to the credentials file to make GCP requests"
}

# Billing Account to be associated with the new Project being created
variable "billing_account_id" {
  description = "The billing account ID to tie with new project"
}

# Project Name
variable "project_name" {
  description = "Name of the new Project being created"
}

# Network Name
variable "network_name" {
  description = "Name of the new VPC Network being created."
}

# Network Subnet Region and CIDRs
variable "subnet_region_and_cidr" {
  type        = "map"
  description = "Network Subnets regions and CIDRs"
  default = {
    "subnet_01_region" = "us-west1"
    "subnet_02_region" = "us-central1"
    "subnet_01_prd"    = "10.10.10.0/24"
    "subnet_01_dev"    = "10.10.11.0/24"
    "subnet_01_tst"    = "10.10.12.0/24"
    "subnet_01_sse"    = "10.10.13.0/24"
    "subnet_02_prd"    = "10.20.10.0/24"
    "subnet_02_dev"    = "10.20.11.0/24"
    "subnet_02_tst"    = "10.20.12.0/24"
    "subnet_02_sse"    = "10.20.13.0/24"
  }
}
