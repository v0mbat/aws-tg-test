include "root" {
  path = find_in_parent_folders("root.terragrunt.hcl")
  expose = true
}

terraform {
  source = "${get_parent_terragrunt_dir()}/../modules//front"
}

dependency "vpc" {
  config_path                             = "../../network/vpc"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "terragrunt-info", "show"] 
  mock_outputs = {
    public_subnets  = ["subnet-fake"]
    private_subnets = ["subnet-priv"]
    vpc_id          = "vpc_fake"
  }
}

dependency "external_security_group" {
  config_path                             = "../../network/sg-external"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "terragrunt-info", "show"]
  mock_outputs = {
    security_group_id = "sg-ext-fake-id"
  }
}

locals {

  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  role_var         = read_terragrunt_config("role.hcl")

  project = local.environment_vars.locals.project
  env     = local.environment_vars.locals.environment
  domain  = local.environment_vars.locals.domain

  role    = local.role_var.locals.role
  region  = local.region_vars.locals.aws_region

  default_tags = include.root.inputs.default_tags
}

inputs = {
  vpc_id    = dependency.vpc.outputs.vpc_id
  subnet_id = element(tolist(coalesce(dependency.vpc.outputs.public_subnets)), 0)
  ec2_env                = local.env
  instance_type          = "t3a.small"
  vpc_security_group_ids = ["${dependency.external_security_group.outputs.security_group_id}"]



  ami = local.region_vars.locals.ubuntu_ami

  key_name = "dimitry-test"

  associate_public_ip_address = true

  enable_volume_tags = false

  name = "${local.env}-${local.role}.${local.domain}"

  role = local.role

  route53_name = "${local.role}"

  availability_zone = "us-east-1a"

  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 125
      volume_size = 30
      tags = merge(
        local.default_tags,
        tomap({ "Name" = "${local.env}-${local.role}-root" })
      )
    },
  ]

  tags = merge(
    local.default_tags,
    tomap({ "Name" = "${local.env}-${local.role}", "Role" = "${local.role}" })
  )
}
