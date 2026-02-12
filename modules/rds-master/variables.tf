
  variable "rds_name" {
    description = "RDS name"
  }

  variable "rds_engine_name" {
    description = "Name of DB engine for RDS"
  }

  variable "rds_engine_version" {
    description = "Version of RDS engine"
  }

  variable "rds_database_name" {
    description = "Name of the default DB"
    default = ""
  }

  variable "rds_master_username" {
    description = "DB superuser name"
    default = ""
  }

variable "rds_type" {
  description = "Instance type for RDS"
}

variable "rds_storage" {
  description = "Size of the allocated storage for RDS"
}

variable "rds_max_allocated_storage" {
  description = "Size of the allocated storage for RDS"
  default = null
}

variable "rds_final_snapshot" {
  description = "Enable/disable snapshot before terminating"
  type = bool
}

variable "rds_license_model" {
  description = "RDS license model"
}

variable "rds_subnet_group" {
  description = "list of subnets for RDS"
  type = string
}

variable "rds_sg" {
  description = "List of security groups for RDS"
  type = list(string)
}

variable "rds_public_access" {
  description = "Enable/disable public access to RDS"
  type = bool
  default = false
}

variable "rds_major_version_upgrade" {
  description = "Enable/disable upgrade of major version of RDS"
  type = bool
  default = false
}

variable "rds_minor_version_upgrade" {
  description = "Enable/disable upgrade of minor version of RDS"
  type = bool
  default = false
}

variable "rds_deletion_protect" {
  description = "Enable/disable deletion protection for RDS"
  type = bool
  default = true
}

variable "rds_storage_encryption" {
  description = "Enable/disable RDS storage encryption"
  type = bool
  default = false
}

variable "rds_parameter_group_family" {
  description = "DB parameter group"
  type = string
  default = "postgres13"
}

variable "rds_parameter_group_name" {
  description = "DB parameter group"
  type = string
  default = "postgres13"
}

variable "rds_multi_az" {
  description = "Enable/disable MultiAZ feature"
  type = bool
  default = false
}

variable "rds_parameter_group_description" {
  description = "Human description of PG"
  type = string
  default = ""
}

variable "rds_parameter_group_parametres" {
  description = "Paramters for PG"
  type = list(any)
  default = [ ]
}

variable "rds_storage_type" {
  description = "Paramters for RDS storage"
  type = string
  default = "gp3"
}

variable "rds_enabled_cloudwatch_logs_exports" {
  description = "Parameter for stream logs to CloudWatch"
  type = set(string)
  default = [ "postgresql" ]
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "rds_copy_tags_to_snapshot" {
  description = "Enable copying tags when snapshot creates"
  type = bool
  default = false
}

variable "rds_backup_retention_period" {
  description = "RDS backup retention period"
  default     = {}
}

variable "rds_apply_immediately" {
  description = "Applying of changes to RDS immediately"
  type = bool
  default = true
}

variable "rds_performance_insights_enabled" {
  description = "Enabled performance insights for RDS"
  type = bool
  default = false
}
