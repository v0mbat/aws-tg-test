locals {
  ingress_with_cidr_blocks_map = {
    for rule in var.ingress_with_cidr_blocks :
    "${rule.from_port}-${rule.to_port}-${rule.protocol}-${replace(split(",", rule.cidr_blocks)[0], "/", "_")}${length(split(",", rule.cidr_blocks)) > 1 ? "-multiple" : ""}" => rule
  }
  egress_with_cidr_blocks_map = {
    for rule in var.egress_with_cidr_blocks :
    "${rule.from_port}-${rule.to_port}-${rule.protocol}-${replace(split(",", rule.cidr_blocks)[0], "/", "_")}${length(split(",", rule.cidr_blocks)) > 1 ? "-multiple" : ""}" => rule
  } 
  ingress_with_source_security_group_id_map = {
    for rule in var.ingress_with_source_security_group_id :
    "${rule.from_port}-${rule.to_port}-${rule.protocol}-${rule.source_security_group_id}" => rule
  }
  egress_with_source_security_group_id_map = {
    for rule in var.egress_with_source_security_group_id :
    "${rule.from_port}-${rule.to_port}-${rule.protocol}-${rule.source_security_group_id}" => rule
  }
    ingress_with_self_map = {
    for rule in var.ingress_with_self :
    "${rule.from_port}-${rule.to_port}-${rule.protocol}-${replace(rule.self, "/", "_")}" => rule
  }
    egress_with_self_map = {
    for rule in var.egress_with_self :
    "${rule.from_port}-${rule.to_port}-${rule.protocol}-${replace(rule.self, "/", "_")}" => rule
  }
}

resource "aws_security_group" "this" {
  name_prefix = "${var.name}-"
  description = var.description
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    { Name = var.name }
  )

  lifecycle {
    ignore_changes = [
      ingress,
      egress
    ]
  }
}

resource "aws_security_group_rule" "ingress" {
  for_each          = local.ingress_with_cidr_blocks_map
  type              = "ingress"
  security_group_id = aws_security_group.this.id
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks = compact([
    for cidr in split(",", each.value.cidr_blocks) : trimspace(cidr)
  ])
  description       = coalesce(each.value.description, "Ingress Rule")
}

resource "aws_security_group_rule" "egress" {
  for_each          = local.egress_with_cidr_blocks_map
  type              = "egress"
  security_group_id = aws_security_group.this.id
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks = compact([
    for cidr in split(",", each.value.cidr_blocks) : trimspace(cidr)
  ])
  description       = coalesce(each.value.description, "Egress Rule")
}

resource "aws_security_group_rule" "ingress_sg" {
  for_each          = local.ingress_with_source_security_group_id_map
  type              = "ingress"
  security_group_id = aws_security_group.this.id
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  source_security_group_id = each.value.source_security_group_id
  description       = coalesce(each.value.description, "Ingress Rule")
}

resource "aws_security_group_rule" "egress_sg" {
  for_each          = local.egress_with_source_security_group_id_map
  type              = "egress"
  security_group_id = aws_security_group.this.id
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  source_security_group_id = each.value.source_security_group_id
  description       = coalesce(each.value.description, "Egress Rule")
}

resource "aws_security_group_rule" "ingress_self" {
  for_each          = local.ingress_with_self_map
  type              = "ingress"
  security_group_id = aws_security_group.this.id
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  self              = each.value.self
  description       = coalesce(each.value.description, "Ingress Rule")
}

resource "aws_security_group_rule" "egress_self" {
  for_each          = local.egress_with_self_map
  type              = "egress"
  security_group_id = aws_security_group.this.id
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  self              = each.value.self
  description       = coalesce(each.value.description, "Egress Rule")
}
