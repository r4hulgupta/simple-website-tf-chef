
# Instance id
output "instance-id" {
  description = "Instance ID of the newly created GCE Instance"
  value = "${google_compute_instance.instance-1.instance_id}"
}

# Instance Private IP
output "instance-private-ip" {
  description = "Private/Internal IP address of the newly created GCE Instance"
  value = "${google_compute_instance.instance-1.network_interface.0.network_ip}"
}
