

/*************************
* Create TLS private key
*************************/
resource "tls_private_key" "key-1" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

/*************************
* Create TLS Cert
*************************/
resource "tls_self_signed_cert" "cert-1" {
  key_algorithm   = "${tls_private_key.key-1.algorithm}"
  private_key_pem = "${tls_private_key.key-1.private_key_pem}"

  # Certificate expires after 300 hours.
  validity_period_hours = 300

  # Generate a new certificate if Terraform is run within three
  # hours of the certificate's expiration time.
  early_renewal_hours = 3

  # Reasonable set of uses for a server SSL certificate.
  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth"
  ]

  dns_names = ["mydnsname.com"]

  subject {
    common_name  = "mydnsname.com"
    organization = "My Organization"
  }
}
