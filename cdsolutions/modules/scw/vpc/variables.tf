variable "zone" {
  type = string
}
variable "environment" {
  type = object({
    short = string
    full  = string
  })
}
##############################
# scaleway_vpc_private_network
##############################
variable "scaleway_vpc_private_network_name" {
  type = string
  description = "(Optional) The name of the private network. If not provided it will be randomly generated."
}
variable "scaleway_vpc_private_network_tags" {
  type = list
  description = "(Optional) The tags associated with the private network."
  default = []
}
################################
# scaleway_vpc_public_gateway_ip
################################
variable scaleway_vpc_public_gateway_ip_reverse {
  type = string
  description = "(Optional) The reverse domain name for the IP address"
  default = ""
}
variable scaleway_vpc_public_gateway_ip_tags {
  type = list
  description = "(Optional) The tags associated with the public gateway IP."
  default = []
}
##################################
# scaleway_vpc_public_gateway_dhcp
##################################
variable "scaleway_vpc_public_gateway_dhcp_subnet" {
  type = string
  description = "(Required) The subnet to associate with the public gateway DHCP config."
  default = ""
}
variable "scaleway_vpc_public_gateway_dhcp_enable_dynamic" {
  description = "(Optional) Whether to enable dynamic pooling of IPs. By turning the dynamic pool off, only pre-existing DHCP reservations will be handed out. Defaults to true."
  type    = bool
  default = true
}
variable "scaleway_vpc_public_gateway_dhcp_pool_low" {
  description = "(Optional) Low IP (included) of the dynamic address pool. Defaults to the second address of the subnet."
  type    = string
  default = null
}
variable "scaleway_vpc_public_gateway_dhcp_pool_high" {
  description = "(Optional) High IP (excluded) of the dynamic address pool. Defaults to the last address of the subnet."
  type    = string
  default = null
}
variable "scaleway_vpc_public_gateway_dhcp_push_default_route" {
  type = bool
  description = "(Optional) Whether the gateway should push a default route to DHCP clients or only hand out IPs. Defaults to false."
  default = false
}
variable "scaleway_vpc_public_gateway_dhcp_push_dns_server" {
  type = bool
  description = "(Optional) Whether the gateway should push custom DNS servers to clients. This allows for instance hostname -> IP resolution. Defaults to true."
  default = true
}
variable "scaleway_vpc_public_gateway_dhcp_dns_servers_override" {
  type = list
  description = "(Optional) Override the DNS server list pushed to DHCP clients, instead of the gateway itself"
  default = [ "1.1.1.1", "8.8.8.8" ]
}
variable "scaleway_vpc_public_gateway_dhcp_dns_search" {
  type = string
  description = "(Optional) Additional DNS search paths"
  default = ""
}
variable "scaleway_vpc_public_gateway_dhcp_dns_local_name" {
  type = string
  description = "(Optional) TLD given to hostnames in the Private Network. Allowed characters are a-z0-9-.. Defaults to the slugified Private Network name if created along a GatewayNetwork, or else to priv."
  default = "priv"
}
#############################
# scaleway_vpc_public_gateway
#############################
variable scaleway_vpc_public_gateway_type {
  type        = string
  default     = ""
  description = "(Required) The gateway type."
}
variable scaleway_vpc_public_gateway_name {
  type        = string
  description = "(Optional) The name of the public gateway. If not provided it will be randomly generated."
  default     = ""
}
variable scaleway_vpc_public_gateway_tags {
  type        = list
  default     = []
  description = "(Optional) The tags associated with the public gateway."
}
variable scaleway_vpc_public_gateway_bastion_enabled {
  type        = bool
  default     = true
  description = "(Optional) Enable SSH bastion on the gateway"
}
variable scaleway_vpc_public_gateway_bastion_port {
  type        = string
  default     = "61000"
  description = "(Optional) The port on which the SSH bastion will listen."
}
##############################
# scaleway_vpc_gateway_network
##############################
variable scaleway_vpc_gateway_network_enable_masquerade {
  type      = bool
  default   = true
  description = " Enable masquerade on this network"
}
variable scaleway_vpc_gateway_network_enable_dhcp {
  type        = bool
  default     = true
  description = "Enable DHCP config on this network. It requires DHCP id."
}
variable scaleway_vpc_gateway_network_cleanup_dhcp {
  type        = bool
  default     = true
  description = "Remove DHCP config on this network on destroy. It requires DHCP id."
}
