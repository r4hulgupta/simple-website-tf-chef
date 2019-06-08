# Project ID where resources are being deployed
variable "project_id" {
  description = "Project ID of project to be used for resource creation"
}

# Code Repository hosting project
variable "code_repo_project" {
  description = "Project ID hosting the deployment code"
}

# Credentials to be used for authenticating with google APIs
variable "credential_file_path" {
  description = "Path to credentials file with GCP access credentials"
}

# Deployment Identifier
variable "service_account_id" {
  description = "Enter the service account ID that will be used to create the service account"
}
