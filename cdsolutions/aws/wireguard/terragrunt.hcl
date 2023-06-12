include "root" {
  path   = find_in_parent_folders()
  expose = true
}

dependency "vpc" {
  config_path = "${get_terragrunt_dir()}/../../vpc"
}

terraform {
  source = ".//module"
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
}

inputs = {
  environment       = local.env_vars.locals.environment
  region            = local.env_vars.locals.aws.region
  vpc_id            = dependency.vpc.outputs.vpc_id
  database_subnets  = dependency.vpc.outputs.database_subnets
  vpn_cidr          = local.env_vars.locals.vpn_subnet
}
