include "root" {
  path   = find_in_parent_folders()
  expose = true
}

dependency "vpc" {
  config_path = "${get_terragrunt_dir()}/../vpc"
}

dependency "wireguard" {
  config_path = "${get_terragrunt_dir()}/../wireguard"
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
}

terraform {
  source = "../..///modules/aws/rds"
}

inputs = {
  environment = local.env_vars.locals.environment
  name        = "cdsolutions"

  vpc_id      = dependency.vpc.outputs.vpc_id
  allow_cidrs = concat([for k, v in dependency.vpc.outputs.database_subnets : v.cidr_block], ["${local.env_vars.locals.scw.subnet}"])

  subnet_ids = dependency.vpc.outputs.database_subnet_ids

  engine_version = "14.2"
  instance_class = "db.t4g.micro"
  backup_retention_period = 7
  allocated_storage = 10
}
