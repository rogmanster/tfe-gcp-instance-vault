terraform {
  required_version = ">= 0.12"
}

provider "vault" {

}

data "vault_generic_secret" "gcp_cred" {
  path = "gcp/token/my-token-roleset"
}

provider "google" {
  #credentials = var.gcp_credentials
  access_token = data.vault_generic_secret.gcp_cred.data["token"]
  project     = var.gcp_project
  region      = var.gcp_region
}

resource "google_compute_instance" "demo" {
  count        = var.instance_count
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.gcp_zone

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }
}
