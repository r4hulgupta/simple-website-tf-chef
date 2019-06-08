variable "project_id" {
  description = "project id of shared VPC project"
}

variable "credential_file_path" {
  description = "Path to credentials file with GCP access credentials"
}

/**************************
Required Input format (example values):
vm_to_create = {
  "machine_name" = "rg2000ba01"
  "machine_type" = "f1-micro"
  "avl_zone" = "us-west1-b"
  "image" = "centos-7"
  "subnet_name" = "projects/guptarhl-rg2000-prj/regions/us-west1/subnetworks/sse-rg2000-us-west1"
  "environment" = "sse"
  "service_account_email" = "project-service-account@guptarhl-rg2000-prj.iam.gserviceaccount.com"
  "tags" = ["allow-ssh"]
  "server_role" = "bastion"
  "startup_script" = <<-EOF
  # !bin/bash
  HOSTNAME=`hostname`
  echo $HOSTNAME
  EOF
}
***************************/
variable "vm_to_create" {
  type = "map"
  description = "Basic GCE configuration for the VM to be created. Please see main.tf file for content/required variables"
}

/**************************
Required Input format (example values):
vm_to_create_lists = {
  "tags" = ["allow-ssh"]
}
***************************/
variable "vm_to_create_lists" {
  type = "map"
  description = "List type values for Basic GCE configuration for the VM to be created. Please see main.tf file for content/required variables"
}