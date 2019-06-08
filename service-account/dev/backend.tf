terraform {
    backend "gcs" {
        bucket = "rg-infra-tf-state"
        prefix = "terraform/state/dev/ws-deploy"
    }
}