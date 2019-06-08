
# Project Name
output "project_name" {
  value       = "${module.project-1.project_name}"
  description = "The name of the new Project being created"
}

# Project ID
output "project_id" {
  value       = "${module.project-1.project_id}"
  description = "The ID of the new Project being created"
}

# VPC Network Name
output "vpc_network_name" {
  value       = "${module.vpc-network-1.network_name}"
  description = "The name of the new VPC Network being created"
}

# VPC Subnetwork names
output "vpc_subnets" {
  value       = "${module.vpc-network-1.subnets_names}"
  description = "The names of the new VPC Subnetworks being created"
}

# VPC Subnetwork CIDRs 
output "vpc_network_cidrs" {
  value       = "${module.vpc-network-1.subnets_ips}"
  description = "The CIDRs of the new VPC Subnetworks being created"
}

# Deployment Helper GCS Bucket Name
output "deployment_helper_bucket" {
  value = "${google_storage_bucket.deployment-helpers.url}"
  description = "URL of the GCS bucket created to store deployment helper scripts and installers"
}
