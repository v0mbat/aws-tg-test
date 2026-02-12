# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# ---------------------------------------------------------------------------------------------------------------------

locals {
  # Define root dir
  root_env_dir = get_parent_terragrunt_dir()
  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  #region_vars = read_terragrunt_config("region.hcl")
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  # Extract the variables we need for easy access
  aws_region           = local.region_vars.locals.aws_region
  env                  = local.environment_vars.locals.environment
  short_region         = local.region_vars.locals.short_region
}

# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
  provider "aws" {
    region = "${local.aws_region}"
  }
EOF
}

generate "versions" {
  path      = "versions.tf"
  if_exists = "overwrite"
  contents  = <<EOF
    terraform {
      required_providers {
        aws = {
          source = "hashicorp/aws"
          version = "~> 5.0"
        }
      }
    }
EOF
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  
  config = {
    encrypt = true
    bucket  = "terragrunt-${local.short_region}"

    key            = "${local.env}/${path_relative_to_include()}/terraform.tfstate"
    region         = "${local.aws_region}"
    use_lockfile = true
  }

  disable_init = tobool(get_env("TG_DISABLE_INIT", "false"))
  
}

# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
  local.region_vars.locals,
  local.environment_vars.locals,
  {
    default_tags = {
      Environment = local.environment_vars.locals.environment
      Mail        = "dimitry.alexeyev@gmail.com"
      ManagedBy   = "Terragrunt - Only IaC Changes"
      Project     = "Test task"
    }
  }
)
