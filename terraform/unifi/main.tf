terraform {
  cloud {
    hostname     = "app.terraform.io"
    organization = "mfin"
    workspaces {
      name = "unifi"
    }
  }

  required_providers {
    unifi = {
      source = "paultyng/unifi"
      version = "0.41.0"
    }

    sops = {
      source  = "carlpett/sops"
      version = "1.3.0"
    }
  }
  required_version = ">= 1.3.0"
}

data "sops_file" "secrets" {
  source_file = "secret.sops.yaml"
}
