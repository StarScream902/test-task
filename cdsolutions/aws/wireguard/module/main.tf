locals {
  instance = {
    name          = "WireGuard"
    instance_type = "t3a.micro"
    ami           = "ami-052efd3df9dad4825" # Ubuntu 22.04
    subnet_id     = var.public_subnets["a"].id
    root_block_device = [
      {
        volume_type = "gp3"
        volume_size = 10
      }
    ]
  }
  wireguard_name = "${title(var.environment.short)}-${local.instance.name}"
  wireguard_tags = {
    Environment = lower(var.environment.full)
  }

}

resource "aws_network_interface" "vpn" {
  subnet_id       = local.instance.subnet_id
  security_groups = [aws_security_group.vpn.id]

  tags = merge(
    local.wireguard_tags,
    tomap({ Name = "${local.wireguard_name}" })
  )
}

resource "aws_eip" "vpn" {
  vpc = true

  tags = merge(
    local.wireguard_tags,
    tomap({ Name = "${local.wireguard_name}-IP" })
  )
}

resource "aws_eip_association" "eip_association_nat" {
  network_interface_id = aws_network_interface.vpn.id
  allocation_id        = aws_eip.vpn.id
}


module "ec2_vpn" {
  source = "./../modules/aws/ec2"

  name        = local.instance.name
  environment = var.environment

  ami                         = local.instance.ami
  instance_type               = local.instance.instance_type
  key_name                    = var.ssh_key_name
  network_interface = [
    {
      device_index          = 0
      network_interface_id  = aws_network_interface.vpn.id
      delete_on_termination = false
    }
  ]

  root_block_device = lookup(local.instance, "root_block_device", [])
}

resource "aws_security_group" "vpn" {
  name        = title(format("%s-VPN-SG", var.environment.short))
  description = "Allow incoming connections"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 51820
    to_port     = 51820
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming wireguard connections"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.wireguard_tags,
    tomap({ Name = "${local.wireguard_name}-SG" })
  )
}

data "aws_vpc" "vpc" {
  id = var.vpc_id
}

data "aws_route_tables" "vpc" {
  vpc_id = data.aws_vpc.vpc.id
}

resource "aws_route" "vpn" {
  for_each               = toset(concat(data.aws_route_tables.vpc.ids, ["${local.env_vars.locals.scw.subnet}"]))
  route_table_id         = each.key
  destination_cidr_block = var.vpn_cidr
  network_interface_id   = aws_network_interface.vpn.id
  depends_on             = [data.aws_route_tables.vpc]
}
