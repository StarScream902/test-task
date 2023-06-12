locals {
  environment = {
    short: "prod",
    full: "production"
  }

  aws {
    region = "us-east-1"

    vpc_cidr = "10.0.0.0/16"

    database_subnets = {
      a: "10.0.0.0/27",
      b: "10.0.0.32/27"
      c: "10.0.0.64/27"
    }
  }
  scw {
    zone    = "fr-par-1"

    subnet  = "10.1.0.0/24"
  }

  vpn_subnet  = "10.255.0.0/24"
  vpn_aws_server = "10.255.0.1"
  vpn_scw_client = "10.255.0.2"
}
