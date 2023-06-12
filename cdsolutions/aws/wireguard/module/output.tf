output "primary_network_interface_id" {
  value = module.ec2_vpn.primary_network_interface_id
}

output "private_ip" {
  value = module.ec2_vpn.private_ip
}

output "public_ip" {
  value = aws_eip.vpn.public_ip
}