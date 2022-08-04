terraform {
#  backend "gcs" {
#    bucket = "emeraldigital-terraform-backend"
#  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.29.0"
    }
  }
}

variable "BACKEND_BUCKET" {
  type = string
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

data "google_storage_project_service_account" "gcs_account" {
}

data "google_kms_key_ring" "keyring" {
  name     = "keyring-emerald"
  location = var.REGION
}

data "google_kms_crypto_key" "backend_key" {
  name            = "crypto-key"
  key_ring        = data.google_kms_key_ring.keyring.id
}

resource "google_kms_crypto_key_iam_member" "crypto_key" {
  crypto_key_id = data.google_kms_crypto_key.backend_key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"
}

resource "google_storage_bucket" "backend" {
  name                        = var.BACKEND_BUCKET
  location                    = var.REGION
  uniform_bucket_level_access = false

  encryption {
    default_kms_key_name = data.google_kms_crypto_key.backend_key.id
  }

  depends_on = [google_kms_crypto_key_iam_member.crypto_key]
}

output "debug" {
  value = {
    bucket : google_storage_bucket.backend.name
  }
}