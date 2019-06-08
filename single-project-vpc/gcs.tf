/*************************
* Locals
*************************/
locals {}

/*************************
* GCS Bucket
*************************/

# Bucket to be used to store deployment helper scripts and installers
resource "google_storage_bucket" "deployment-helpers" {
    name = "${module.project-1.project_id}-deployment-helpers"
    project = "${module.project-1.project_id}"
    versioning {
        enabled = "true"
    }
}
