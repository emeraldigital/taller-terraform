output "instances" {
  value = [
  for instance in google_compute_instance.vm_example : {
    name : instance.name
    ip : instance.network_interface[0].access_config[0].nat_ip
  }
  ]
}

output "network_load_balancer_ip" {
  value = google_compute_forwarding_rule.network-load-balancer.ip_address
}