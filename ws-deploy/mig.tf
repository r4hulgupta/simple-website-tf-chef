/*************************
* Locals
*************************/
locals {
  mig_name = "${var.deployment_id}-mig"
}

/*************************
* GCE Managed Instance Group Template
*************************/
module "webserver_template" {
  #source       = "github.com/terraform-google-modules/terraform-google-vm/modules/instance_template"
  source       = "terraform-google-modules/vm/google//modules/instance_template"
  name_prefix  = "${local.mig_name}-template"
  machine_type = "${var.machine_type}"
  tags         = "${var.tags}"
  metadata     = "${var.metadata}"

  service_account = "${var.service_account}"

  subnetwork           = "${var.subnetwork_name}"
  source_image_project = "${var.source_image_project}"
  source_image         = "${var.source_image}"
  disk_size_gb         = "${var.disk_size_gb}"
  disk_type            = "${var.disk_type}"
  auto_delete          = "${var.auto_delete_disk}"

  // additional_disks = "${var.additional_disks}"
}

/*************************
* GCE Managed Instance Group
*************************/
module "webserver_mig" {
  source            = "terraform-google-modules/vm/google//modules/mig"
  instance_template = "${module.webserver_template.self_link}"
  hostname          = "${local.mig_name}"
  region            = "${var.region}"

  autoscaling_enabled = "${var.enable_autoscaling}"
  min_replicas        = "${var.min_replicas}"
}
