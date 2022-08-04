locals {
  is_default_vpc = var.NETWORK == "default"
}

resource "google_compute_network" "vpc_network" {
  count = local.is_default_vpc ? 0 : 1
  name = var.NETWORK
}

data "google_compute_network" "default_vpc" {
  name = "default"
}

resource "google_compute_firewall" "allow_ipv4" {
  name    = "${var.NETWORK}-allow-http"
  network = local.is_default_env ? data.google_compute_network.default_vpc.name : google_compute_network.vpc_network[0].name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  priority = 1000
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_ssh" {
  count = var.ALLOW_SSH ? 1 : 0
  name    = "${var.NETWORK}-allow-ssh"
  network = local.is_default_env ? data.google_compute_network.default_vpc.name : google_compute_network.vpc_network[0].name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  priority = 1000
  source_ranges = ["0.0.0.0/0"]
}
