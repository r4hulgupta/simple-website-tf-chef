
# Project ID where resources are being deployed
variable "project_id" {
  description = "Project ID of project to be used for resource creation"
}

# Credentials to be used for authenticating with google APIs
variable "credential_file_path" {
  description = "Path to credentials file with GCP access credentials"
}

# Region to be used for MIG creation
variable "region" {
  description = "The GCP region where MIG instances will be deployed."
}

# VPC to be used to deploy environment
variable "network_name" {
  description = "Name of the VPC Network where the instances will be deployed"
}

# Deployment Identifier
variable "deployment_id" {
  description = "Enter a deployment identifier that is unique to this deployment"
}

/*************************
* MIG Template Variables 
*************************/
variable "machine_type" {
  description = "Machine type for instances"
  default     = "n1-standard-1"
}

variable "tags" {
  type        = "list"
  description = "List of Network tags to be applied to instances"
  default     = []
}

variable "source_image" {
  description = "OS Image to be used to create instances"
  default     = ""
}

variable "source_image_project" {
  description = "Project that owns the source OS image"
  default     = ""
}

variable "auto_delete_disk" {
  description = "Auto delete the disk when instance is deleted"
  default     = "true"
}

variable "disk_size_gb" {
  description = "Size of disk to be attached to the instance"
  default     = "10"
}

variable "disk_type" {
  description = "Type of disk to be attached to the instance"
  default     = "pd-standard"
}

variable "metadata" {
  type        = "map"
  description = "Map of custom metadata key value pairs e.g. startup_script_url"
  default     = {}
}

variable "service_account" {
  type        = "map"
  description = "Map of service account email and scopes key value pairs"
}

variable "subnetwork_name" {
  description = "Name of the subnet where the instances will be deployed by default when using the template."
}


/*************************
* MIG Cluster Variables 
*************************/
variable "enable_http_healthcheck" {
  description = "Enable HTTP healthchecks"
  default     = "true"
}

variable "hc_path" {
  description = "Health check http path to check."
  default     = "/"
}

variable "hc_port" {
  description = "Health check port."
  default     = "80"
}
variable "min_replicas" {
  description = "The minimum number of replicas that the autoscaler can scale down to"
  default     = 2
}

variable "enable_autoscaling" {
  description = "Enable Autoscaling on MIG cluster"
  default = "true"
}



/*************************
* Load Balancer Variables 
*************************/

# Healthcheck port protocol name
variable "healthcheck_port_name" {
  description = "Port protocol name for the health check port (Ex: http, tcp)"
  default = "http"
}

# Healthcheck port number
variable "healthcheck_port_number" {
  description = "Port number for the health check port (Ex: 80, 443)"
  default = "80"
}

variable "healthcheck_target_path" {
  description = "Target path to perform healthchecks on"
  default = "/index.html"
}
