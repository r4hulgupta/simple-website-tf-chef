terraform {
    backend "gcs" {
        bucket = "<TF_BUCKET_NAME>"
        prefix = "terraform/state/dev/service-account"
    }
}