locals {
  public_inbound_map = {
    for r in var.public_inbound_acl_rules :
    tostring(r.rule_number) => r
  }
  public_outbound_map = {
    for r in var.public_outbound_acl_rules :
    tostring(r.rule_number) => r
  }
  private_inbound_map = {
    for r in var.private_inbound_acl_rules :
    tostring(r.rule_number) => r
  }
  private_outbound_map = {
    for r in var.private_outbound_acl_rules :
    tostring(r.rule_number) => r
  }
  database_inbound_map = {
    for r in var.database_inbound_acl_rules :
    tostring(r.rule_number) => r
  }
  database_outbound_map = {
    for r in var.database_outbound_acl_rules :
    tostring(r.rule_number) => r
  }
}