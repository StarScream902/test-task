terraform {
  required_version = ">= 1.1.6"

  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
      version = ">= 2.6.0"
    }
  }
}
