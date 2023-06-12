include "root" {
  path   = find_in_parent_folders()
  expose = true
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
}

terraform {
  source = "../..///modules/aws/vpc"
}

inputs = {
  environment       = local.env_vars.locals.environment
  region            = local.env_vars.locals.aws.region
  vpc_cidr          = local.env_vars.locals.aws.vpc_cidr

  database_subnets  = local.env_vars.locals.aws.database_subnets
}
