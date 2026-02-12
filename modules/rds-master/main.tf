### Create password with Secret Manager

resource "random_password" "this"{
  length           = 16
  special          = true
  override_special = "_!%^"
}

resource "aws_secretsmanager_secret" "this" {
  #name = "master-db-password"
  name = "${var.rds_name}-master-password"
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id = aws_secretsmanager_secret.this.id
  secret_string = random_password.this.result
}

/* ### Get password from Secret

data "aws_secretsmanager_secret" "password" {
  name = "master-db-password"

}

data "aws_secretsmanager_secret_version" "password" {
  secret_id = data.aws_secretsmanager_secret.password
} */


### Let define new parameter group for RDS


resource "aws_db_parameter_group" "this" {
  name   = var.rds_parameter_group_name
  family = var.rds_parameter_group_family
  description = var.rds_parameter_group_description


  dynamic "parameter" {
    for_each = var.rds_parameter_group_parametres
    content {
    apply_method = parameter.value.apply_method
    name = parameter.value.name
    value = parameter.value.value
    }
  }
}

resource "aws_db_instance" "this" {
  identifier                  = var.rds_name
  engine                      = var.rds_engine_name
  engine_version              = var.rds_engine_version
  db_name                     = var.rds_database_name
  username                    = var.rds_master_username
  password                    = aws_secretsmanager_secret_version.this.secret_string
  instance_class              = var.rds_type
  allocated_storage           = var.rds_storage
  max_allocated_storage       = var.rds_max_allocated_storage
  skip_final_snapshot         = var.rds_final_snapshot
  license_model               = var.rds_license_model
  db_subnet_group_name        = var.rds_subnet_group
  vpc_security_group_ids      = var.rds_sg
  publicly_accessible         = var.rds_public_access
  parameter_group_name        = aws_db_parameter_group.this.id
  allow_major_version_upgrade = var.rds_major_version_upgrade
  auto_minor_version_upgrade  = var.rds_minor_version_upgrade
  deletion_protection         = var.rds_deletion_protect
  storage_encrypted           = var.rds_storage_encryption
  multi_az                    = var.rds_multi_az
  storage_type                = var.rds_storage_type
  enabled_cloudwatch_logs_exports = var.rds_enabled_cloudwatch_logs_exports
  copy_tags_to_snapshot = var.rds_copy_tags_to_snapshot
  apply_immediately = var.rds_apply_immediately
  performance_insights_enabled = var.rds_performance_insights_enabled


  backup_retention_period     = var.rds_backup_retention_period

  tags = merge(
    var.tags
  )
}
