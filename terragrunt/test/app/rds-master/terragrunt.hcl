include "root" {
  path   = find_in_parent_folders("root.terragrunt.hcl")
  expose = true
}

terraform {
  source = "${get_parent_terragrunt_dir()}/../modules//rds-master"
}

dependency "vpc" {
  config_path                             = "../../network/vpc"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "terragrunt-info", "show"] 
  mock_outputs = {
    public_subnets        = ["subnet-fake"]
    private_subnets       = ["subnet-priv"]
    database_subnet_group = ["subnet-db"]
    vpc_id                = "vpc_fake"
  }
}

dependency "security_group" {
  config_path                             = "../../network/sg-internal"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "terragrunt-info", "show"]
  mock_outputs = {
    security_group_id = "sg-int-fake-id"
  }
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  role_var         = read_terragrunt_config("role.hcl")

  project      = local.environment_vars.locals.project
  env          = local.environment_vars.locals.environment
  short_env    = local.environment_vars.locals.environment
  role         = local.role_var.locals.role
  region       = local.region_vars.locals.aws_region

  default_tags = include.root.inputs.default_tags
}

inputs = {

  rds_name                         = "${local.short_env}-${local.role}"
  rds_engine_name                  = "postgres"
  rds_engine_version               = "17.2"
  rds_database_name                = "test"
  rds_master_username              = "dba"
  rds_type                         = "db.t4g.small"
  rds_storage                      = "100"
  rds_final_snapshot               = true
  rds_license_model                = "postgresql-license"
  rds_subnet_group                 = dependency.vpc.outputs.database_subnet_group
  rds_sg                           = ["${dependency.security_group.outputs.security_group_id}"]
  rds_public_access                = false
  rds_major_version_upgrade        = false
  rds_minor_version_upgrade        = false
  rds_deletion_protect             = true
  rds_storage_encryption           = true
  rds_multi_az                     = true
  rds_copy_tags_to_snapshot        = true
  rds_apply_immediately            = false
  rds_performance_insights_enabled = true

  rds_backup_retention_period = "3"


  rds_storage_type = "gp3"


  rds_parameter_group_name        = "${local.short_env}-${local.role}"
  rds_parameter_group_family      = "postgres17"
  rds_parameter_group_description = "instance parameters ${local.short_env}-${local.role}"

  rds_parameter_group_parametres = [
    {
      apply_method = "immediate"
      name         = "rds.force_ssl"
      value        = "1"
    },
    {
      apply_method = "immediate"
      name         = "password_encryption"
      value        = "md5"
    },
    {
      apply_method = "immediate"
      name         = "ssl_ciphers"
      value        = "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384"
    },
  ]


  tags = merge(
    local.default_tags,
    tomap({ "Name" = "${local.short_env}-${local.role}" })
  )
}
