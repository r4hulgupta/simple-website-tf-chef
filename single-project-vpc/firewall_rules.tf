/*************************
* Locals
*************************/
locals {}

/*************************
* Firewall rules
*************************/

# Allow health check from google health check endpoints to instances with target tag allow-health-check
resource "google_compute_firewall" "allow_http_healthcheck_ingress" {
  name    = "${module.vpc-network-1.network_name}-allow-http-healthcheck-ingress"
  project   = "${module.project-1.project_id}"
  network = "${module.vpc-network-1.network_name}"

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  target_tags   = ["allow-health-check"]
  direction     = "INGRESS"
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
}

# All private google access to google restricted API endpoint
resource "google_compute_firewall" "allow_all_private_google_access" {
  name    = "${module.vpc-network-1.network_name}-allow-private-google-access"
  project   = "${module.project-1.project_id}"
  network = "${module.vpc-network-1.network_name}"

  allow {
    protocol = "all"
  }

  direction          = "EGRESS"
  destination_ranges = ["199.36.153.4/30"]
}

# Allow SSH based on tags
resource "google_compute_firewall" "allow_tag_based_ssh_access" {
  name    = "${module.vpc-network-1.network_name}-allow-tag-based-ssh-access"
  project = "${module.project-1.project_id}"
  network = "${module.vpc-network-1.network_name}"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags   = ["allow-ssh-from-internet"]
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
}
