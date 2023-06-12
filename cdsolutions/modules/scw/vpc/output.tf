# scaleway_vpc_public_gateway_ip
output "scaleway_vpc_public_gateway_ip_address" {
  value = scaleway_vpc_public_gateway_ip.this.address
}
output "scaleway_vpc_public_gateway_ip_zone" {
  value = scaleway_vpc_public_gateway_ip.this.zone
}
output "scaleway_vpc_private_network_id" {
  value = scaleway_vpc_private_network.this.id
}
output "scaleway_vpc_gateway_network_id" {
  value = scaleway_vpc_gateway_network.this.id
}
output "scaleway_vpc_public_gateway_id" {
  value = scaleway_vpc_public_gateway.this.id
}
