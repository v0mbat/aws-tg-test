data "aws_region" "current" {}


# ----------------------------------------------------------------------------------------------------------------------
# Local Variables
# ----------------------------------------------------------------------------------------------------------------------

locals {
  prefix = var.ec2_env
  role   = var.role
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.0"

  name                   = var.name

  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.vpc_security_group_ids
  subnet_id              = var.subnet_id
  associate_public_ip_address = var.associate_public_ip_address
  create_eip             = var.create_eip
  iam_instance_profile = var.iam_instance_profile
  metadata_options       = var.metadata_options

  enable_volume_tags = var.enable_volume_tags
  root_block_device  = var.root_block_device
  ebs_block_device   = var.ebs_block_device

  tags = merge(
    var.tags,
    tomap({ "Name" = "${var.name}" })
    )
}
