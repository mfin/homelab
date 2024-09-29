terraform {
  cloud {
    hostname     = "app.terraform.io"
    organization = "mfin"
    workspaces {
      name = "cloudflare"
    }
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.19.0"
    }

    http = {
      source  = "hashicorp/http"
      version = "3.4.5"
    }

    sops = {
      source  = "carlpett/sops"
      version = "1.0.0"
    }
  }
  required_version = ">= 1.3.0"
}

data "sops_file" "secrets" {
  source_file = "secret.sops.yaml"
}
