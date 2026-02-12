include "root" {
  path   = find_in_parent_folders("root.terragrunt.hcl")
  expose = true
}

terraform {
  source = "${get_parent_terragrunt_dir()}/../modules//vpc/"
}

locals {

  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  project = local.environment_vars.locals.project
  env          = local.environment_vars.locals.environment
  region       = local.region_vars.locals.aws_region
  cidr         = "172.10.0.0/16"
  name         = "${local.env}-VPC"

  default_tags = include.root.inputs.default_tags
}

inputs = {
  namespace     = local.project
  environment   = local.env
  name          = "${local.env}-VPC"
  cidr          = "${local.cidr}"
  use_ipam_pool = true

  azs                          = ["${local.region}a", "${local.region}b"]
  create_database_subnet_group = true
  database_subnet_group_name   = "${local.env}-DB-group"
  create_igw                   = true

  public_subnets   = ["172.10.10.0/25", "172.10.10.128/25"]
  private_subnets  = ["172.10.11.0/25"]
  database_subnets = ["172.10.12.0/25", "172.10.12.128/25"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  single_nat_gateway = false

  manage_default_security_group = true
  default_security_group_tags   = { Name = "${local.name}-default" }

  public_subnet_tags = { Role = "public" }

  enable_dns_hostnames = true
/*
  database_dedicated_network_acl = true
  database_inbound_acl_rules = [
    {
      "cidr_block" : "0.0.0.0/0",
      "from_port" : 5432,
      "protocol" : "tcp",
      "rule_action" : "allow",
      "rule_number" : 100,
      "to_port" : 5432
    }
  ]

  database_outbound_acl_rules = [
    {
      "cidr_block" : "0.0.0.0/0",
      "from_port" : 1024,
      "protocol" : "tcp",
      "rule_action" : "allow",
      "rule_number" : 100,
      "to_port" : 65534
    }
  ]

  */

  tags = merge(
    local.default_tags
  )
}
