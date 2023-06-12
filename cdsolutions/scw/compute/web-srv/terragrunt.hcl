include "root" {
  path   = find_in_parent_folders()
  expose = true
}

dependency "vpc" {
  config_path = "${get_terragrunt_dir()}/../../vpc"
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
}

terraform {
  source = "../../..//modules/scw/compute/"
}

inputs = {
  environment = local.env_vars.locals.environment
  zone        = local.env_vars.locals.scw.zone
  tags        = [ local.env_vars.locals.scw.zone ]

  scaleway_instance_security_group_name                     = "web-srv"
  scaleway_instance_security_group_description              = "web-srv security group"
  scaleway_instance_security_group_inbound_default_policy   = "drop"
  scaleway_instance_security_group_inbound_rule             = [
    {
      action      = "accept"
      protocol    = "TCP"
      port_range  = "80-80"
      ip_range    = "0.0.0.0/0"
    },
    {
      action      = "accept"
      protocol    = "TCP"
      port_range  = "443-443"
      ip_range    = "0.0.0.0/0"
    },
    {
      action      = "accept"
      protocol    = "ANY"
      port_range  = "0-0"
      ip_range    = local.env_vars.locals.vpc_subnet
    }
  ]

  scaleway_instance_ip_create = true

  scaleway_instance_server = [
    {
      name          = "http-to-web-srv-1"
      priv_ip       = "10.100.1.3"
      pat_rule_private_port  = 80
      pat_rule_public_port   = 80
      pat_rule_protocol      = "TCP"
    }
  ]
  scaleway_instance_server_type               = "DEV1-S"
  scaleway_instance_server_image              = "ubuntu_jammy"
  scaleway_instance_server_user_data          = "${get_terragrunt_dir()}/cloud-init.sh"
  scaleway_instance_server_private_network_id = dependency.vpc.outputs.scaleway_vpc_private_network_id
  scaleway_instance_server_root_volume = {
    size_in_gb  = 20
    volume_type = "l_ssd"
  }
  additional_volume_ids = []
  tags = [ "web-srv-1" ]

  scaleway_vpc_public_gateway_dhcp_reservation_gateway_network_id = dependency.vpc.outputs.scaleway_vpc_gateway_network_id

  scaleway_vpc_public_gateway_pat_rule_gateway_id = dependency.vpc.outputs.scaleway_vpc_public_gateway_id
}
