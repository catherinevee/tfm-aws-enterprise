# =============================================================================
# Basic Enterprise Infrastructure Example
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
# Basic Enterprise Infrastructure
# =============================================================================

module "enterprise_infrastructure" {
  source = "../../"

  environment = "dev"

  # VPC Configuration
  create_main_vpc        = true
  create_production_vpc  = false
  create_development_vpc = false

  # Transit Gateway
  create_transit_gateway = false

  # VPN Configuration
  create_vpn = false

  # Load Balancers
  create_alb = false
  create_nlb = false

  # VPC Endpoints
  create_vpc_endpoints = false

  # NAT Gateway
  enable_nat_gateway = true

  # Common Tags
  common_tags = {
    Environment = "dev"
    Project     = "basic-example"
    Owner       = "devops-team"
    CostCenter  = "IT-001"
  }
}

# =============================================================================
# Outputs
# =============================================================================

output "main_vpc_id" {
  description = "ID of the main VPC"
  value       = module.enterprise_infrastructure.main_vpc_id
}

output "main_public_subnet_ids" {
  description = "IDs of the main VPC public subnets"
  value       = module.enterprise_infrastructure.main_public_subnet_ids
}

output "main_private_subnet_ids" {
  description = "IDs of the main VPC private subnets"
  value       = module.enterprise_infrastructure.main_private_subnet_ids
}

output "vpc_summary" {
  description = "Summary of VPCs created"
  value       = module.enterprise_infrastructure.vpc_summary
} 