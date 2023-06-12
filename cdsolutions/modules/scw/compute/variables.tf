variable "zone" {
  description = "(Defaults to provider zone) The zone in which the security group should be created."
  type        = string
}
variable "environment" {
  type = object({
    short = string
    full  = string
  })
}
##################################
# scaleway_instance_security_group
##################################
variable "scaleway_instance_security_group_name" {
  description = "(Optional) The name of the security group."
  type        = string
  default     = ""
}
variable "scaleway_instance_security_group_description" {
  description = "(Optional) The description of the security group."
  type        = string
  default     = ""
}
variable "scaleway_instance_security_group_stateful" {
  description = "(Defaults to true) A boolean to specify whether the security group should be stateful or not."
  type        = bool
  default     = true
}
variable "scaleway_instance_security_group_inbound_default_policy" {
  description = "(Defaults to accept) The default policy on incoming traffic. Possible values are: accept or drop."
  type        = string
  default     = "accept"
}
variable "scaleway_instance_security_group_outbound_default_policy" {
  description = "(Defaults to accept) The default policy on outgoing traffic. Possible values are: accept or drop."
  type        = string
  default     = "accept"
}
variable "scaleway_instance_security_group_enable_default_security" {
  description = "Whether to block SMTP on IPv4/IPv6 (Port 25, 465, 587). Set to false will unblock SMTP if your account is authorized to. If your organization is not yet authorized to send SMTP traffic, open a support ticket."
  type        = bool
  default     = true
}
variable "scaleway_instance_security_group_inbound_rule" {
  description = "(Optional) A list of inbound rule to add to the security group. (Structure is documented below.)"
  type = list(object({
    action      = string
    protocol    = string
    port_range  = string
    ip_range    = string
    # tags        = string
  }))
  default = []
}
variable "scaleway_instance_security_group_outbound_rule" {
  description = "(Optional) A list of outbound rule to add to the security group. (Structure is documented below.)"
  type = list(object({
    action      = string
    protocol    = string
    port_range  = string
    ip_range    = string
    # tags        = string
  }))
  default = []
}
######################
# scaleway_instance_ip
######################
variable "scaleway_instance_ip_create" {
  description = "create public IP?"
  type        = bool
  default     = false
}
##########################
# scaleway_instance_server
##########################
variable "scaleway_instance_server" {
  description = "A server parameters"
  type = any
  # type = list(object({
  #   name          = string
  #   priv_ip       = string
  #   pat_rule_private_port  = number
  #   pat_rule_public_port   = number
  #   pat_rule_protocol      = string
  # }))
  default = null
}
variable "scaleway_instance_server_type" {
  description = "(Required) The commercial type of the server. You find all the available types on the pricing page. Updates to this field will recreate a new resource."
  type        = string
  default     = ""
}
variable "scaleway_instance_server_image" {
  description = "(Optional) The UUID or the label of the base image used by the server. You can use this endpoint to find either the right label or the right local image ID for a given type. Optional when creating an instance with an existing root volume."
  type        = string
  default     = ""
}
variable "scaleway_instance_server_enable_dynamic_ip" {
  description = ""
  type        = bool
  default     = false
}
variable "scaleway_instance_server_enable_ipv6" {
  description = ""
  type        = bool
  default     = false
}
variable "scaleway_instance_server_user_data" {
  description = "(Optional) The user data associated with the server. Use the cloud-init key to use cloud-init on your instance. You can define values using:"
  default     = ""
  type        = string
}
variable "scaleway_instance_server_private_network_id" {
  description = ""
  type        = string
  default     = ""
}
variable "scaleway_instance_server_root_volume" {
  description = ""
  type = object({
    size_in_gb  = number 
    volume_type = string
  })
  default     = null
}
variable "scaleway_instance_server_additional_volume_ids" {
  type        = list
  default     = []
  description = ""
}
variable "scaleway_instance_server_tags" {
  type        = list
  default     = []
  description = ""
}
##############################################
# scaleway_vpc_public_gateway_dhcp_reservation
##############################################
variable "scaleway_vpc_public_gateway_dhcp_reservation_gateway_network_id" {
  description = ""
  type        = string
  default     = ""
}
variable "scaleway_vpc_public_gateway_dhcp_reservation_ip_address" {
  description = ""
  type        = string
  default     = ""
}
######################################
# scaleway_vpc_public_gateway_pat_rule
######################################
variable "scaleway_vpc_public_gateway_pat_rule_gateway_id" {
  description = "(Required) The ID of the public gateway."
  default = ""
  type = string
}
variable "scaleway_vpc_public_gateway_pat_rule_private_ip" {
  description = "(Required) The Private IP to forward data to (IP address)."
  default = ""
  type = string
}
variable "scaleway_vpc_public_gateway_pat_rule_public_port" {
  description = "(Required) The Public port to listen on."
  default = ""
  type = string
}
variable "scaleway_vpc_public_gateway_pat_rule_private_port" {
  description = "(Required) The Private port to translate to."
  default = ""
  type = string
}
variable "scaleway_vpc_public_gateway_pat_rule_protocol" {
  description = "(Defaults to both) The Protocol the rule should apply to. Possible values are both, tcp and udp."
  default = ""
  type = string
}
