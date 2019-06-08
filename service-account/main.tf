/*************************
* Locals
*************************/
locals {
}

/*************************
* Provider configuration
*************************/
provider "google" {
  credentials = "${file("${var.credential_file_path}")}"
  project = "${var.project_id}"
}

# Service account to be used by this deployment/application
resource "google_service_account" "webserver_svc" {
  account_id   = "${var.service_account_id}"
  display_name = "Service Account for WebService"
  project      = "${var.project_id}"
}

# Read only permissions to GCS buckets
resource "google_project_iam_binding" "gcs_readonly_perm_webserver_svc" {
  members = [
    "serviceAccount:${google_service_account.webserver_svc.email}",
  ]
  project = "${var.project_id}"
  role    = "roles/storage.objectViewer"
}

# Read only permissions to Cloud Source Repositories in Infra Project
resource "google_project_iam_binding" "csr_readonly_perm_webserver_svc" {
  members = [
    "serviceAccount:${google_service_account.webserver_svc.email}",
  ]
  project = "${var.code_repo_project}"
  role    = "roles/source.reader"
}

# Stackdriver monitoring permissions 
resource "google_project_iam_binding" "sd_monitoring_write_perm_webserver_svc" {
  members = [
    "serviceAccount:${google_service_account.webserver_svc.email}",
  ]
  project = "${var.project_id}"
  role    = "roles/monitoring.metricWriter"
}

# Stackdriver log writer permissions 
resource "google_project_iam_binding" "sd_logging_write_perm_webserver_svc" {
  members = [
    "serviceAccount:${google_service_account.webserver_svc.email}",
  ]
  project = "${var.project_id}"
  role    = "roles/logging.logWriter"
}
