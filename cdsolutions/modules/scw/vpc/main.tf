locals {
  tags = {
    Environment = lower(var.environment.full)
  }
}

resource "scaleway_vpc_private_network" "this" {
  zone = var.zone
  name = "${var.zone}-${var.scaleway_vpc_private_network_name}"
  tags = concat(
    [
      lower(var.environment.short),
      lower(var.environment.full),
      var.zone,
      var.scaleway_vpc_private_network_name
    ],
    var.scaleway_vpc_private_network_tags
  )
}

resource "scaleway_vpc_public_gateway_ip" "this" {
  zone    = var.zone
  reverse = var.scaleway_vpc_public_gateway_ip_reverse
  tags    = var.scaleway_vpc_public_gateway_ip_tags
}

resource "scaleway_vpc_public_gateway_dhcp" "this" {
  zone                  = var.zone
  subnet                = var.scaleway_vpc_public_gateway_dhcp_subnet
  enable_dynamic        = var.scaleway_vpc_public_gateway_dhcp_enable_dynamic
  pool_low              = var.scaleway_vpc_public_gateway_dhcp_pool_low
  pool_high             = var.scaleway_vpc_public_gateway_dhcp_pool_high
  push_default_route    = var.scaleway_vpc_public_gateway_dhcp_push_default_route
  push_dns_server       = var.scaleway_vpc_public_gateway_dhcp_push_dns_server
  dns_servers_override  = var.scaleway_vpc_public_gateway_dhcp_dns_servers_override
  dns_local_name        = var.scaleway_vpc_public_gateway_dhcp_dns_local_name
}

resource "scaleway_vpc_public_gateway" "this" {
  zone            = var.zone
  name            = "${var.zone}-${var.scaleway_vpc_public_gateway_name}"
  type            = var.scaleway_vpc_public_gateway_type
  bastion_enabled = var.scaleway_vpc_public_gateway_bastion_enabled
  bastion_port    = var.scaleway_vpc_public_gateway_bastion_port
  ip_id           = scaleway_vpc_public_gateway_ip.this.id
}

resource "scaleway_vpc_gateway_network" "this" {
  zone                = var.zone
  gateway_id          = scaleway_vpc_public_gateway.this.id
  private_network_id  = scaleway_vpc_private_network.this.id
  dhcp_id             = scaleway_vpc_public_gateway_dhcp.this.id
  enable_masquerade   = var.scaleway_vpc_gateway_network_enable_masquerade
  enable_dhcp         = var.scaleway_vpc_gateway_network_enable_dhcp
  cleanup_dhcp        = var.scaleway_vpc_gateway_network_cleanup_dhcp
  depends_on = [scaleway_vpc_public_gateway_ip.this, scaleway_vpc_private_network.this]
}
