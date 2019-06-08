/*************************
* Locals
*************************/
locals {
  lb_name = "${var.deployment_id}-lb"
}

/*************************
* Create HTTPS Load Balancer
*************************/
module "lb-https" {
  source            = "github.com/GoogleCloudPlatform/terraform-google-lb-http"
  name              = "${local.lb_name}"
  firewall_networks = ["${var.network_name}"]
  ssl               = true
  private_key       = "${tls_private_key.key-1.private_key_pem}"
  certificate       = "${tls_self_signed_cert.cert-1.cert_pem}"
  target_tags       = "${var.tags}"
  backends = {
    "0" = [{
      group = "${module.webserver_mig.instance_group}"
    }]
  }

  backend_params = [
    // health check path, port name, port number, timeout seconds.
    "${var.healthcheck_target_path},${var.healthcheck_port_name},${var.healthcheck_port_number},30",
  ]
}
