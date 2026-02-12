data "aws_region" "current" {}

# ----------------------------------------------------------------------------------------------------------------------
# Local Variables
# ----------------------------------------------------------------------------------------------------------------------

locals {
  prefix = var.ec2_env
  role   = var.role
  domain = var.domain

  subnet_list = length(var.subnet_ids) > 0 ? var.subnet_ids : [var.subnet_id]

  instance_map = { 
    for idx, num in var.number : num => {
      instance_number = num
      subnet_id       = local.subnet_list[idx % length(local.subnet_list)]
    }
  }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.0"

  for_each = local.instance_map

  name                   = "${var.name}-${each.key}"

  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.vpc_security_group_ids
  subnet_id              = each.value.subnet_id
  iam_instance_profile   = var.iam_instance_profile
  metadata_options       = var.metadata_options
  ignore_ami_changes     = var.ignore_ami_changes

  enable_volume_tags = var.enable_volume_tags
  root_block_device  = var.root_block_device

  tags = merge(
    var.tags,
    tomap({ "Name" = "${local.prefix}-${local.role}-${each.key}.${local.domain}" })
    #tomap({ "Name" = "${var.name}-${each.key}.${data.aws_route53_zone.main.name}" })
    #tomap({ "Name" = "${var.name}-${each.key}" })
    )
}
