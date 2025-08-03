# =============================================================================
# Main Test Configuration
# =============================================================================

variables {
  environment = "test"
  create_main_vpc = true
  main_vpc_cidr = "10.0.0.0/16"
  create_production_vpc = false
  create_development_vpc = false
  common_tags = {
    Environment = "test"
    Project     = "enterprise-test"
    Terraform   = "true"
  }
}

# Test VPC Creation
run "verify_main_vpc_creation" {
  command = plan

  assert {
    condition     = length(aws_vpc.main) > 0
    error_message = "Main VPC was not created when create_main_vpc = true"
  }
}

run "verify_main_vpc_cidr" {
  command = plan

  assert {
    condition     = aws_vpc.main[0].cidr_block == var.main_vpc_cidr
    error_message = "Main VPC CIDR block does not match the specified value"
  }
}

# Test Production VPC
run "verify_no_production_vpc" {
  command = plan

  assert {
    condition     = length(aws_vpc.production) == 0
    error_message = "Production VPC was created when create_production_vpc = false"
  }
}

# Test Development VPC
run "verify_no_development_vpc" {
  command = plan

  assert {
    condition     = length(aws_vpc.development) == 0
    error_message = "Development VPC was created when create_development_vpc = false"
  }
}

# Test Tag Application
run "verify_vpc_tags" {
  command = plan

  assert {
    condition     = length(aws_vpc.main[0].tags) > 0
    error_message = "Tags were not applied to the main VPC"
  }
}
