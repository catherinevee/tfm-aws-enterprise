# =============================================================================
# Test Configuration for Enterprise Multi-VPC Infrastructure Module
# =============================================================================

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# =============================================================================
# Test Module Configuration
# =============================================================================

module "test_infrastructure" {
  source = "../"

  environment = "test"

  # VPC Configuration
  create_main_vpc        = true
  create_production_vpc  = false
  create_development_vpc = false

  # Transit Gateway
  create_transit_gateway = true

  # VPN Configuration (disabled for testing)
  create_vpn = false

  # Load Balancers
  create_alb = true
  create_nlb = true

  alb_internal = false
  nlb_internal = true

  alb_deletion_protection = false
  nlb_deletion_protection = false

  # VPC Endpoints
  create_vpc_endpoints = true

  # NAT Gateway
  enable_nat_gateway = true

  # Common Tags
  common_tags = {
    Environment = "test"
    Project     = "module-testing"
    Owner       = "test-team"
    Purpose     = "testing"
  }
}

# =============================================================================
# Test Outputs
# =============================================================================

output "test_vpc_id" {
  description = "ID of the test VPC"
  value       = module.test_infrastructure.main_vpc_id
}

output "test_subnet_ids" {
  description = "IDs of the test VPC subnets"
  value = {
    public  = module.test_infrastructure.main_public_subnet_ids
    private = module.test_infrastructure.main_private_subnet_ids
  }
}

output "test_transit_gateway_id" {
  description = "ID of the test Transit Gateway"
  value       = module.test_infrastructure.transit_gateway_id
}

output "test_load_balancers" {
  description = "Test load balancer information"
  value = {
    alb_id       = module.test_infrastructure.alb_id
    alb_dns_name = module.test_infrastructure.alb_dns_name
    nlb_id       = module.test_infrastructure.nlb_id
    nlb_dns_name = module.test_infrastructure.nlb_dns_name
  }
}

output "test_vpc_endpoints" {
  description = "Test VPC endpoint IDs"
  value = {
    s3       = module.test_infrastructure.s3_vpc_endpoint_id
    dynamodb = module.test_infrastructure.dynamodb_vpc_endpoint_id
    ec2      = module.test_infrastructure.ec2_vpc_endpoint_id
    ecr      = module.test_infrastructure.ecr_vpc_endpoint_id
    ecr_dkr  = module.test_infrastructure.ecr_dkr_vpc_endpoint_id
  }
}

output "test_summary" {
  description = "Test infrastructure summary"
  value = {
    vpc_summary           = module.test_infrastructure.vpc_summary
    load_balancer_summary = module.test_infrastructure.load_balancer_summary
    connectivity_summary  = module.test_infrastructure.connectivity_summary
  }
} 