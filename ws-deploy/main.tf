

/*************************
* Provider configuration
*************************/
provider "google" {
  credentials = "${file("${var.credential_file_path}")}"
  project = "${var.project_id}"
  region = "${var.region}"
}

provider "google-beta" {
  credentials = "${file("${var.credential_file_path}")}"
  project = "${var.project_id}"
  region = "${var.region}"
}
