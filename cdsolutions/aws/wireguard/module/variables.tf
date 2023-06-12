variable "environment" {
  type = object({
    short = string
    full = string
  })
}

variable "ssh_key_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  type = any
}

variable "vpn_cidr" {
  type = string
}

#variable "corp_prod_vpc_peering_id" {
#  type = string
#}
#
#variable "prod_vpc_id" {
#  type = string
#}