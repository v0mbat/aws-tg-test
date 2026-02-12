include {
    path = find_in_parent_folders("root.terragrunt.hcl")
    expose = true
}

terraform {
  source = "${get_parent_terragrunt_dir()}/../modules//cloudfront"
}

dependency "front" {
  config_path                             = "../front"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "terragrunt-info", "show"] 
  mock_outputs = {
     public_dns = "fake_public_dns"
  }
}

dependency "r53" {
    config_path = "../r53"
    mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "terragrunt-info", "show"]
    mock_outputs = {
        domain_name = "fake_domain_name"
        hosted_zone_id = "fake_hosted_zone_id"
    }
}

inputs = {
    origin_endpoint = dependency.front.outputs.public_dns
    domain_name = dependency.r53.outputs.domain_name
    aliases = ["ec2.test.xyz"]
    hosted_zone_id = dependency.r53.outputs.hosted_zone_id
}
