# =============================================================================
# Complete Enterprise Infrastructure Example
# =============================================================================

provider "aws" {
  region = "us-west-2"
  
  default_tags {
    tags = {
      ManagedBy = "terraform"
      Module    = "tfm-aws-enterprise"
    }
  }
}

module "enterprise_infrastructure" {
  source = "../../"

  environment = "prod"
  
  # VPC Configuration
  create_main_vpc        = true
  main_vpc_cidr         = "10.0.0.0/16"
  create_production_vpc  = true
  production_vpc_cidr   = "10.1.0.0/16"
  create_development_vpc = true
  development_vpc_cidr  = "10.2.0.0/16"

  # Enable Advanced Features
  main_vpc_enable_dns_hostnames = true
  main_vpc_enable_dns_support   = true
  main_vpc_assign_generated_ipv6_cidr_block = true

  production_vpc_enable_dns_hostnames = true
  production_vpc_enable_dns_support   = true
  production_vpc_assign_generated_ipv6_cidr_block = true

  development_vpc_enable_dns_hostnames = true
  development_vpc_enable_dns_support   = true
  development_vpc_assign_generated_ipv6_cidr_block = true

  # Tags
  common_tags = {
    Environment = "prod"
    Project     = "enterprise-complete"
    Terraform   = "true"
    Owner       = "platform-team"
    CostCenter  = "platform"
  }
}
