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
