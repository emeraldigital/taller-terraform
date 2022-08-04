resource "google_compute_http_health_check" "nlb-hc" {
  name               = "nlb-health-checks-${var.NETWORK}"
  request_path       = "/"
  port               = 80
  check_interval_sec = 10
  timeout_sec        = 3
}

resource "google_compute_target_pool" "nlb-target-pool" {
  name             = "nlb-target-pool-${var.NETWORK}"
  session_affinity = "NONE"
  region           = var.REGION

  instances = [for instance in google_compute_instance.vm_example: instance.self_link]

  health_checks = [
    google_compute_http_health_check.nlb-hc.name
  ]
}

resource "google_compute_forwarding_rule" "network-load-balancer" {
  name                  = "nlb-test-${var.NETWORK}"
  region                = var.REGION
  target                = google_compute_target_pool.nlb-target-pool.self_link
  port_range            = "80"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
}
