/*output "aws_vpc_id" {
  value = aws_vpc.main.id
}

 output "subnet_public_a_id" {
  value = aws_subnet.public_a.id
}

output "subnet_public_b_id" {
  value = aws_subnet.public_b.id
}

output "subnet_private_a_id" {
  value = aws_subnet.private_a.id
}
 */
/*
output "public_instance_ip" {
  value = module.ec2_instance.public_ip
}
*/

/*
resource "local_file" "AnsibleInventory" {
  content = templatefile("inventory.tmpl",
    {
      public_instance_ip  = module.ec2_instance.public_ip
      private_instance_ip = module.ec2_instance.private_ip
      instance_name       = "${var.route53_name}.${data.aws_route53_zone.main.name}"

    }
  )
  filename = "../../ansible-inventory/inventory-${local.role}"
}
*/
