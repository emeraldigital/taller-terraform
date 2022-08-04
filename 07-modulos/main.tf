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
  default = "us-east1"
}

provider "google" {
  project = var.PROJECT_ID
  region  = var.REGION
}

provider "google-beta" {
  project     = var.PROJECT_ID
  region      = var.REGION
}

module "load_balancer" {
  source = "./load_balancer"

  # Input Variables
  PROJECT_ID = var.PROJECT_ID
  NETWORK = terraform.workspace
  N_INSTANCES = 2
}

output "instances" {
  value = module.load_balancer.instances
}

output "load_balancer_ip" {
  value = module.load_balancer.network_load_balancer_ip
}

output "environment" {
  value = terraform.workspace
}