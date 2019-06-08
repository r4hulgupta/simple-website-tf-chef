
# Service account email
output "email" {
  description = "Email of the newly created service account"
  value = "${google_service_account.webserver_svc.email}"
}
