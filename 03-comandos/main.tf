terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.29.0"
    }
  }
}

variable "PROJECT_ID" {
  type = string
}

variable "REGION" {
  type = string
}

provider "google" {
  project = var.PROJECT_ID
  region  = var.REGION
}

data "google_compute_zones" "available" {
}

resource "google_compute_instance" "vm_example" {
  name         = "vm-example"
  machine_type = "e2-micro"
  zone         = data.google_compute_zones.available.names[0]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  metadata_startup_script = "sudo apt-get update; sudo apt install apache2 -y"

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }
}

resource "google_compute_firewall" "allow_ipv4" {
  name    = "apache-app-firewall-for-ipv4"
  network = "default"
  #  direction = "EGRESS"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  priority = 1000

  source_ranges = ["0.0.0.0/0"]
}

output "vm_ip" {
  value = google_compute_instance.vm_example.network_interface[0].access_config[0].nat_ip
}
