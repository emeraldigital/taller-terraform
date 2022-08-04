data "google_compute_zones" "available" {
}

locals {
  is_default_env = terraform.workspace == "default"
}

resource "google_compute_instance" "vm_example" {
  count        = var.N_INSTANCES
  name         = "vm-instance-${count.index}-${var.NETWORK}"
  machine_type = var.MACHINE_TYPE
  zone         = data.google_compute_zones.available.names[0]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  metadata = {
    startup-script = <<-EOF
      sudo apt update;
      sudo apt -y install apache2;
      sudo chown -R $USER:$USER /var/www;
      echo "<html><body><h1>Hello From ${"vm-instance-${count.index}"}${local.is_default_env ? "" : ", current environment is ${terraform.workspace}" }</h1></body></html>" > /var/www/html/index.html;
    EOF
  }

  network_interface {
    network = local.is_default_env ? data.google_compute_network.default_vpc.name : google_compute_network.vpc_network[0].name

    access_config {
      // Ephemeral public IP
    }
  }
}
