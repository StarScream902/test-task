output "scaleway_instance_public_ip" {
  value = [
    for scaleway_instance_pub_ip in scaleway_instance_server.this : "${scaleway_instance_pub_ip.public_ip} ${scaleway_instance_pub_ip.name}"
  ]
}
output "scaleway_instance_scw_private_ip" {
  value = [
    for scaleway_instance_scw_priv in scaleway_instance_server.this : "${scaleway_instance_scw_priv.private_ip} ${scaleway_instance_scw_priv.name}"
  ]
}
output "scaleway_instance_private_dhcp_ip" {
  value = [
    for scaleway_instance_dhcp_priv_ip in scaleway_vpc_public_gateway_dhcp_reservation.this : "${scaleway_instance_dhcp_priv_ip.ip_address} ${scaleway_instance_dhcp_priv_ip.hostname}"
  ]
}
