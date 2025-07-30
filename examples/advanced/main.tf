# =============================================================================
# Advanced Enterprise Infrastructure Example
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
# Advanced Enterprise Infrastructure
# =============================================================================

module "enterprise_infrastructure" {
  source = "../../"

  environment = "prod"

  # VPC Configuration - Create all VPCs
  create_main_vpc        = true
  create_production_vpc  = true
  create_development_vpc = true

  # Custom CIDR blocks
  main_vpc_cidr        = "10.0.0.0/16"
  production_vpc_cidr  = "10.1.0.0/16"
  development_vpc_cidr = "10.2.0.0/16"

  # Custom subnet configurations
  main_public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  main_private_subnets = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]

  production_public_subnets  = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  production_private_subnets = ["10.1.11.0/24", "10.1.12.0/24", "10.1.13.0/24"]

  development_public_subnets  = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]
  development_private_subnets = ["10.2.11.0/24", "10.2.12.0/24", "10.2.13.0/24"]

  # Transit Gateway for VPC connectivity
  create_transit_gateway = true

  # VPN Configuration for hybrid connectivity
  create_vpn               = true
  customer_gateway_ip      = "203.0.113.1" # Replace with your on-premises gateway IP
  customer_gateway_bgp_asn = 65000
  vpn_static_routes_only   = false

  # Load Balancers
  create_alb = true
  create_nlb = true

  # Load balancer configuration
  alb_internal = false # External ALB for public access
  nlb_internal = true  # Internal NLB for private services

  alb_deletion_protection = true
  nlb_deletion_protection = true

  alb_target_port = 80
  nlb_target_port = 80

  alb_health_check_path = "/health"

  # VPC Endpoints for private AWS service access
  create_vpc_endpoints = true

  # NAT Gateways for private subnet internet access
  enable_nat_gateway = true

  # Common Tags
  common_tags = {
    Environment = "production"
    Project     = "enterprise-platform"
    Owner       = "platform-team"
    CostCenter  = "IT-001"
    DataClass   = "confidential"
    Compliance  = "SOX"
  }
}

# =============================================================================
# Outputs
# =============================================================================

output "vpc_summary" {
  description = "Summary of all VPCs created"
  value       = module.enterprise_infrastructure.vpc_summary
}

output "load_balancer_summary" {
  description = "Summary of load balancers created"
  value       = module.enterprise_infrastructure.load_balancer_summary
}

output "connectivity_summary" {
  description = "Summary of connectivity resources created"
  value       = module.enterprise_infrastructure.connectivity_summary
}

output "transit_gateway_id" {
  description = "ID of the Transit Gateway"
  value       = module.enterprise_infrastructure.transit_gateway_id
}

output "vpn_connection_id" {
  description = "ID of the VPN Connection"
  value       = module.enterprise_infrastructure.vpn_connection_id
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.enterprise_infrastructure.alb_dns_name
}

output "nlb_dns_name" {
  description = "DNS name of the Network Load Balancer"
  value       = module.enterprise_infrastructure.nlb_dns_name
}

output "vpc_endpoints" {
  description = "VPC Endpoint IDs"
  value = {
    s3       = module.enterprise_infrastructure.s3_vpc_endpoint_id
    dynamodb = module.enterprise_infrastructure.dynamodb_vpc_endpoint_id
    ec2      = module.enterprise_infrastructure.ec2_vpc_endpoint_id
    ecr      = module.enterprise_infrastructure.ecr_vpc_endpoint_id
    ecr_dkr  = module.enterprise_infrastructure.ecr_dkr_vpc_endpoint_id
  }
} 