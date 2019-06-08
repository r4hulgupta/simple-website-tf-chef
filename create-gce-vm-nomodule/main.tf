
/*************************
* Locals
*************************/
locals {}

/*************************
* Provider configuration
*************************/
provider "google" {
  credentials = "${file("${var.credential_file_path}")}"
}

/*************************
* GCE Instance Creation
*************************/
resource "google_compute_instance" "instance-1" {
  project      = "${var.project_id}"
  name         = "${var.vm_to_create["machine_name"]}"
  machine_type = "${var.vm_to_create["machine_type"]}"
  zone         = "${var.vm_to_create["avl_zone"]}"
  tags         = "${var.vm_to_create_lists["tags"]}"

  boot_disk {
    initialize_params {
      image = "${var.vm_to_create["image"]}"
    }
  }

  network_interface {
    subnetwork         = "${var.vm_to_create["subnet_name"]}"
    subnetwork_project = "${var.project_id}"
    // access_config      = {}
  }

  metadata {
    server-role = "${var.vm_to_create["server_role"]}"
    environment = "${var.vm_to_create["environment"]}"
  }

  metadata_startup_script = "${var.vm_to_create["startup_script"]}"

  service_account {
    scopes = ["cloud-platform"]
    email  = "${var.vm_to_create["service_account_email"]}"
  }
}
