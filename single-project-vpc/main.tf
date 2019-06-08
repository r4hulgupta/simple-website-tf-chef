/*************************
* Locals
*************************/
locals {
  subnet_01_region   = "${var.subnet_region_and_cidr["subnet_01_region"]}" // "us-west1"
  subnet_02_region   = "${var.subnet_region_and_cidr["subnet_02_region"]}" // "us-central1"
  subnet_01          = "${var.network_name}-${local.subnet_01_region}"
  subnet_02          = "${var.network_name}-${local.subnet_02_region}"
  subnet_01_prd_cidr = "${var.subnet_region_and_cidr["subnet_01_prd"]}"    // "10.30.10.0/24"
  subnet_01_dev_cidr = "${var.subnet_region_and_cidr["subnet_01_dev"]}"    // "10.30.11.0/24"
  subnet_01_tst_cidr = "${var.subnet_region_and_cidr["subnet_01_tst"]}"    // "10.30.12.0/24"
  subnet_01_sse_cidr = "${var.subnet_region_and_cidr["subnet_01_sse"]}"    // "10.30.13.0/24"
  subnet_02_prd_cidr = "${var.subnet_region_and_cidr["subnet_02_prd"]}"    // "10.40.10.0/24"
  subnet_02_dev_cidr = "${var.subnet_region_and_cidr["subnet_02_dev"]}"    // "10.40.11.0/24"
  subnet_02_tst_cidr = "${var.subnet_region_and_cidr["subnet_02_tst"]}"    // "10.40.12.0/24"
  subnet_02_sse_cidr = "${var.subnet_region_and_cidr["subnet_02_sse"]}"    // "10.40.13.0/24"
}

/*************************
* Provider configuration
*************************/
provider "google" {
  credentials = "${file(var.credentials_file_path)}"
  version     = "~> 2.1"
}

provider "google-beta" {
  credentials = "${file(var.credentials_file_path)}"
  version     = "~> 2.1"
}

/*************************
* Create a single project and single custom VPC
*************************/

# Create a project
module "project-1" {
  source            = "terraform-google-modules/project-factory/google"
  name              = "${var.project_name}"
  credentials_path  = "${var.credentials_file_path}"
  random_project_id = "false"

  activate_apis = [
    "compute.googleapis.com",
    "cloudbilling.googleapis.com",
    "storage-api.googleapis.com",
    "sourcerepo.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com"
  ]

  org_id              = "${var.organization_id}"
  auto_create_network = "false"
  billing_account     = "${var.billing_account_id}"
}

# Create Custom private VPC inside the project
module "vpc-network-1" {
  source       = "terraform-google-modules/network/google"
  network_name = "${var.network_name}"
  project_id   = "${module.project-1.project_id}"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name           = "prd-${local.subnet_01}"
      subnet_region         = "${local.subnet_01_region}"
      subnet_ip             = "${local.subnet_01_prd_cidr}"
      subnet_private_access = "true"
    },
    {
      subnet_name           = "dev-${local.subnet_01}"
      subnet_region         = "${local.subnet_01_region}"
      subnet_ip             = "${local.subnet_01_dev_cidr}"
      subnet_private_access = "true"
    },
    {
      subnet_name           = "tst-${local.subnet_01}"
      subnet_region         = "${local.subnet_01_region}"
      subnet_ip             = "${local.subnet_01_tst_cidr}"
      subnet_private_access = "true"
    },
    {
      subnet_name           = "sse-${local.subnet_01}"
      subnet_region         = "${local.subnet_01_region}"
      subnet_ip             = "${local.subnet_01_sse_cidr}"
      subnet_private_access = "true"
    },
    {
      subnet_name           = "prd-${local.subnet_02}"
      subnet_region         = "${local.subnet_02_region}"
      subnet_ip             = "${local.subnet_02_prd_cidr}"
      subnet_private_access = "true"
    },
    {
      subnet_name           = "dev-${local.subnet_02}"
      subnet_region         = "${local.subnet_02_region}"
      subnet_ip             = "${local.subnet_02_dev_cidr}"
      subnet_private_access = "true"
    },
    {
      subnet_name           = "tst-${local.subnet_02}"
      subnet_region         = "${local.subnet_02_region}"
      subnet_ip             = "${local.subnet_02_tst_cidr}"
      subnet_private_access = "true"
    },
    {
      subnet_name           = "sse-${local.subnet_02}"
      subnet_region         = "${local.subnet_02_region}"
      subnet_ip             = "${local.subnet_02_sse_cidr}"
      subnet_private_access = "true"
    },
  ]

  secondary_ranges = {
    "prd-${local.subnet_01}" = []
    "dev-${local.subnet_01}" = []
    "tst-${local.subnet_01}" = []
    "sse-${local.subnet_01}" = []
    "prd-${local.subnet_02}" = []
    "dev-${local.subnet_02}" = []
    "tst-${local.subnet_02}" = []
    "sse-${local.subnet_02}" = []
  }

  routes = [
    {
      name              = "private-google-access"
      description       = "Route to private google access endpoints through default IGW"
      destination_range = "199.36.153.4/30"
      next_hop_internet = "true"
    },
  ]
}
