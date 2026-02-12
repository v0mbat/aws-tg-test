output "security_group_arn" {
  value = aws_security_group.this.arn
}

output "security_group_id" {
  value = aws_security_group.this.id
}

output "security_group_vpc_id" {
  value = aws_security_group.this.vpc_id
}

output "security_group_owner_id" {
  value = aws_security_group.this.owner_id
}

output "security_group_name" {
  value = aws_security_group.this.name
}

output "security_group_description" {
  value = aws_security_group.this.description
}
