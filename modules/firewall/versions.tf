terraform {
  required_version = ">= 1.11"
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.50.1"
    }
  }
}
