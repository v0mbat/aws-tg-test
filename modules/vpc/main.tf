module "vpc_this" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.12"

  name = var.name
  cidr = var.cidr

  azs                          = var.azs
  create_database_subnet_group = var.create_database_subnet_group
  database_subnet_group_name   = var.database_subnet_group_name
  create_igw                   = var.create_igw

  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets
  database_subnets = var.database_subnets

  enable_nat_gateway = var.enable_nat_gateway
  enable_vpn_gateway = var.enable_vpn_gateway

  single_nat_gateway = var.single_nat_gateway

  public_inbound_acl_rules  = var.public_inbound_acl_rules
  public_outbound_acl_rules = var.public_outbound_acl_rules
  map_public_ip_on_launch   = var.map_public_ip_on_launch

  private_inbound_acl_rules  = var.private_inbound_acl_rules
  private_outbound_acl_rules = var.private_outbound_acl_rules

  manage_default_security_group = var.manage_default_security_group
  default_security_group_tags   = var.default_security_group_tags

  public_subnet_tags = { Role = "public" }
  tags               = var.tags

  enable_flow_log                                 = var.enable_flow_log
  flow_log_destination_type                       = var.flow_log_destination_type
  flow_log_cloudwatch_log_group_retention_in_days = var.flow_log_cloudwatch_log_group_retention_in_days
  flow_log_traffic_type                           = var.flow_log_traffic_type
  flow_log_max_aggregation_interval               = var.flow_log_max_aggregation_interval
  create_flow_log_cloudwatch_iam_role             = var.create_flow_log_cloudwatch_iam_role
  create_flow_log_cloudwatch_log_group            = var.create_flow_log_cloudwatch_log_group
  flow_log_cloudwatch_log_group_class             = var.flow_log_cloudwatch_log_group_class
  vpc_flow_log_tags                               = var.vpc_flow_log_tags  

  enable_dns_hostnames = var.enable_dns_hostnames

  manage_default_network_acl  = var.manage_default_network_acl
  default_network_acl_name    = var.default_network_acl_name
  default_network_acl_egress  = var.default_network_acl_egress
  default_network_acl_ingress = var.default_network_acl_ingress
  database_inbound_acl_rules  = var.database_inbound_acl_rules

  database_outbound_acl_rules = var.database_outbound_acl_rules

  public_dedicated_network_acl   = false
  private_dedicated_network_acl  = false
  database_dedicated_network_acl = false
}

resource "aws_network_acl" "public_nacl" {
  count      = var.public_dedicated_network_acl ? 1 : 0
  vpc_id     = module.vpc_this.vpc_id
  subnet_ids = module.vpc_this.public_subnets

  tags = merge(
    var.tags,
    { Name = "${var.name}-public" }
  )
}

resource "aws_network_acl_rule" "public_inbound" {
  for_each       = var.public_dedicated_network_acl ? local.public_inbound_map : {}
  network_acl_id = aws_network_acl.public_nacl[0].id

  rule_number     = each.value.rule_number
  protocol        = each.value.protocol
  egress          = lookup(each.value, "egress", false)
  rule_action     = each.value.rule_action
  from_port       = lookup(each.value, "from_port", null)
  to_port         = lookup(each.value, "to_port", null)
  cidr_block      = lookup(each.value, "cidr_block", null)
  ipv6_cidr_block = lookup(each.value, "ipv6_cidr_block", null)
  icmp_type       = lookup(each.value, "icmp_type", null)
  icmp_code       = lookup(each.value, "icmp_code", null)
}

resource "aws_network_acl_rule" "public_outbound" {
  for_each       = var.public_dedicated_network_acl ? local.public_outbound_map : {}
  network_acl_id = aws_network_acl.public_nacl[0].id

  rule_number     = each.value.rule_number
  protocol        = each.value.protocol
  egress          = true
  rule_action     = each.value.rule_action
  from_port       = lookup(each.value, "from_port", null)
  to_port         = lookup(each.value, "to_port", null)
  cidr_block      = lookup(each.value, "cidr_block", null)
  ipv6_cidr_block = lookup(each.value, "ipv6_cidr_block", null)
  icmp_type       = lookup(each.value, "icmp_type", null)
  icmp_code       = lookup(each.value, "icmp_code", null)
}

resource "aws_network_acl" "private_nacl" {
  count      = var.private_dedicated_network_acl ? 1 : 0
  vpc_id     = module.vpc_this.vpc_id
  subnet_ids = module.vpc_this.private_subnets

  tags = merge(
    var.tags,
    { Name = "${var.name}-private" }
  )
}

resource "aws_network_acl_rule" "private_inbound" {
  for_each       = var.private_dedicated_network_acl ? local.private_inbound_map : {}
  network_acl_id = aws_network_acl.private_nacl[0].id

  rule_number     = each.value.rule_number
  protocol        = each.value.protocol
  egress          = false
  rule_action     = each.value.rule_action
  from_port       = lookup(each.value, "from_port", null)
  to_port         = lookup(each.value, "to_port", null)
  cidr_block      = lookup(each.value, "cidr_block", null)
  ipv6_cidr_block = lookup(each.value, "ipv6_cidr_block", null)
  icmp_type       = lookup(each.value, "icmp_type", null)
  icmp_code       = lookup(each.value, "icmp_code", null)
}

resource "aws_network_acl_rule" "private_outbound" {
  for_each       = var.private_dedicated_network_acl ? local.private_outbound_map : {}
  network_acl_id = aws_network_acl.private_nacl[0].id

  rule_number     = each.value.rule_number
  protocol        = each.value.protocol
  egress          = true
  rule_action     = each.value.rule_action
  from_port       = lookup(each.value, "from_port", null)
  to_port         = lookup(each.value, "to_port", null)
  cidr_block      = lookup(each.value, "cidr_block", null)
  ipv6_cidr_block = lookup(each.value, "ipv6_cidr_block", null)
  icmp_type       = lookup(each.value, "icmp_type", null)
  icmp_code       = lookup(each.value, "icmp_code", null)
}

resource "aws_network_acl" "database_nacl" {
  count      = var.database_dedicated_network_acl ? 1 : 0
  vpc_id     = module.vpc_this.vpc_id
  subnet_ids = module.vpc_this.database_subnets

  tags = merge(
    var.tags,
    { Name = "${var.name}-db" }
  )
}

resource "aws_network_acl_rule" "database_inbound" {
  for_each       = var.database_dedicated_network_acl ? local.database_inbound_map : {}
  network_acl_id = aws_network_acl.database_nacl[0].id

  rule_number     = each.value.rule_number
  protocol        = each.value.protocol
  egress          = false
  rule_action     = each.value.rule_action
  from_port       = lookup(each.value, "from_port", null)
  to_port         = lookup(each.value, "to_port", null)
  cidr_block      = lookup(each.value, "cidr_block", null)
  ipv6_cidr_block = lookup(each.value, "ipv6_cidr_block", null)
  icmp_type       = lookup(each.value, "icmp_type", null)
  icmp_code       = lookup(each.value, "icmp_code", null)
}

resource "aws_network_acl_rule" "database_outbound" {
  for_each       = var.database_dedicated_network_acl ? local.database_outbound_map : {}
  network_acl_id = aws_network_acl.database_nacl[0].id

  rule_number     = each.value.rule_number
  protocol        = each.value.protocol
  egress          = true
  rule_action     = each.value.rule_action
  from_port       = lookup(each.value, "from_port", null)
  to_port         = lookup(each.value, "to_port", null)
  cidr_block      = lookup(each.value, "cidr_block", null)
  ipv6_cidr_block = lookup(each.value, "ipv6_cidr_block", null)
  icmp_type       = lookup(each.value, "icmp_type", null)
  icmp_code       = lookup(each.value, "icmp_code", null)
}