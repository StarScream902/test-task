resource "scaleway_instance_security_group" "this" {
  zone                    = var.zone
  name                    = "${var.zone}-${var.scaleway_instance_security_group_name}"
  description             = var.scaleway_instance_security_group_description
  stateful                = var.scaleway_instance_security_group_stateful
  inbound_default_policy  = var.scaleway_instance_security_group_inbound_default_policy
  outbound_default_policy = var.scaleway_instance_security_group_outbound_default_policy
  enable_default_security = var.scaleway_instance_security_group_enable_default_security

  dynamic "inbound_rule" {
    for_each = { for v in var.scaleway_instance_security_group_inbound_rule : "${v.protocol}-${v.ip_range}-${v.port_range}-${v.action}" => v }
    content {
      protocol    = inbound_rule.value.protocol
      ip_range    = inbound_rule.value.ip_range
      port_range  = inbound_rule.value.port_range
      action      = inbound_rule.value.action
    }
  }
  dynamic "outbound_rule" {
    for_each = { for v in var.scaleway_instance_security_group_outbound_rule : "${v.protocol}-${v.ip_range}-${v.port_range}-${v.action}" => v }
    content {
      protocol    = outbound_rule.value.protocol
      ip_range    = outbound_rule.value.ip_range
      port_range  = outbound_rule.value.port_range
      action      = outbound_rule.value.action
    }
  }
}

resource "scaleway_instance_ip" "this" {
  for_each = {
    for v in var.scaleway_instance_server : "${v.name}-${v.priv_ip}" => v
    if var.scaleway_instance_ip_create
  }

  zone  = var.zone
}

resource "scaleway_instance_server" "this" {
  for_each = {
    for v in var.scaleway_instance_server : "${v.name}-${v.priv_ip}" => v
  }

  zone              = var.zone

  name              = "${lower(var.environment.short)}-${var.zone}-${each.value.name}"
  type              = var.scaleway_instance_server_type
  image             = var.scaleway_instance_server_image
  enable_dynamic_ip = var.scaleway_instance_server_enable_dynamic_ip
  enable_ipv6       = var.scaleway_instance_server_enable_ipv6
  ip_id             = var.scaleway_instance_ip_create ? scaleway_instance_ip.this["${each.value.name}-${each.value.priv_ip}"].id : null
  user_data         = var.scaleway_instance_server_user_data != null ? { foo = "bar", cloud-init = file(var.scaleway_instance_server_user_data) } : null
  security_group_id = scaleway_instance_security_group.this.id
  private_network {
    pn_id = var.scaleway_instance_server_private_network_id
  }
  root_volume {
    size_in_gb  = var.scaleway_instance_server_root_volume.size_in_gb
    volume_type = var.scaleway_instance_server_root_volume.volume_type
  }
  additional_volume_ids = var.scaleway_instance_server_additional_volume_ids
  tags = concat(
    [
      lower(var.environment.short),
      lower(var.environment.full),
      each.value.name
    ],
    var.scaleway_instance_server_tags
  )
  depends_on = [
    scaleway_instance_ip.this,
    scaleway_instance_security_group.this
  ]
}

resource "scaleway_vpc_public_gateway_dhcp_reservation" "this" {
  depends_on = [ scaleway_instance_ip.this ]
  for_each = {
    for v in var.scaleway_instance_server : "${v.name}-${v.priv_ip}" => v
  }

  gateway_network_id  = var.scaleway_vpc_public_gateway_dhcp_reservation_gateway_network_id
  mac_address         = scaleway_instance_server.this["${each.value.name}-${each.value.priv_ip}"].private_network.0.mac_address
  ip_address          = each.value.priv_ip
}

resource "scaleway_vpc_public_gateway_pat_rule" "this" {
  for_each = {
    for v in var.scaleway_instance_server : "${v.name}-${v.priv_ip}" => v
    if try(v.pat_rule_private_port, 0) > 0 && try(v.pat_rule_public_port, 0) > 0 && try(v.pat_rule_protocol, "") != ""
  }

  zone              = var.zone

  gateway_id    = var.scaleway_vpc_public_gateway_pat_rule_gateway_id
  private_ip    = each.value.priv_ip
  private_port  = each.value.pat_rule_private_port
  public_port   = each.value.pat_rule_public_port
  protocol      = each.value.pat_rule_protocol
}
