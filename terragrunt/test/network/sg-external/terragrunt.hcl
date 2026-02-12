include "root" {
  path = find_in_parent_folders("root.terragrunt.hcl")
  expose = true
}

terraform {
  source = "${get_parent_terragrunt_dir()}/../modules//security-group/"
}

dependency "vpc" {
  config_path                             = "../vpc"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "terragrunt-info", "show"]
  mock_outputs = {
    vpc_id                      = "vpc-fake-id"
    private_subnets             = ["10.1.0.0/16"]
    public_subnets              = ["32.0.0.0/16"]
    private_subnets_cidr_blocks = ["10.1.0.0/16"]
    vpc_cidr_block              = "10.11.0.0/16"
  }
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  project     = local.environment_vars.locals.project
  env         = local.environment_vars.locals.environment

  default_tags = include.root.inputs.default_tags
}

inputs = {

  name         = "${local.env}-external-sg"
  description  = "Security group for ${local.env}"
  vpc_id       = dependency.vpc.outputs.vpc_id
  namespace    = local.project
  environment  = local.env
  subnets_ids  = ["${dependency.vpc.outputs.private_subnets}", "${dependency.vpc.outputs.public_subnets}"]

  ingress_with_cidr_blocks = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "HTTPS"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "SSH"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "${dependency.vpc.outputs.vpc_cidr_block}"
      description = "Rule for SSH access"
    },
    {
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      cidr_blocks = "${dependency.vpc.outputs.vpc_cidr_block}"
      description = "Rule for ping access"
    },
  ]

  egress_with_cidr_blocks = [

    {
      from_port   = 123
      to_port     = 123
      protocol    = "udp"
      cidr_blocks = "169.254.169.123/32"
      description = "Rule for AWS NTP"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "apt update"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "apt update"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = 6
      description = "SSH access"
      cidr_blocks = "${dependency.vpc.outputs.vpc_cidr_block}"
    },
    {
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      cidr_blocks = "${dependency.vpc.outputs.vpc_cidr_block}"
      description = "Rule for ping access"
    },
  ]

  tags = merge(
    local.default_tags
  )
}
