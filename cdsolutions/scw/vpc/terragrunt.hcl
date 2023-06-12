include "root" {
  path   = find_in_parent_folders()
  expose = true
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
}

terraform {
  source = "../..///modules/scw/vpc"
}

inputs = {
  zone  = local.env_vars.locals.zone

  environment = local.env_vars.locals.environment

  scaleway_vpc_public_gateway_dhcp_subnet         = local.env_vars.locals.scw.subnet
  scaleway_vpc_public_gateway_dhcp_enable_dynamic = false

  scaleway_vpc_private_network_name = "private"

  scaleway_vpc_public_gateway_name  = "cdsolutions"
  scaleway_vpc_public_gateway_type  = "VPC-GW-S"
}
