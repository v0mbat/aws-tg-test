locals {
  project     = "Test task"
  environment = "test"
  domain      = "example.com"
  tags = {
    Environment = "test"
    Project     = "Test task"
    ManagedBy   = "Terraform - Only IaC Changes"
  }
}
