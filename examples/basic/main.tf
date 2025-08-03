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

  # Basic Configuration
  environment = "dev"  # Default: dev - Environment name for resource naming

  # VPC Configuration
  create_main_vpc        = true   # Default: true - Create main VPC
  create_production_vpc  = false  # Default: false - Create production VPC (disabled for basic example)
  create_development_vpc = false  # Default: false - Create development VPC (disabled for basic example)

  # Main VPC Advanced Configuration
  main_vpc_enable_dns_hostnames = true   # Default: true - Enable DNS hostnames for instances
  main_vpc_enable_dns_support = true     # Default: true - Enable DNS support for the VPC
  main_vpc_assign_generated_ipv6_cidr_block = false  # Default: false - Assign IPv6 CIDR block
  main_vpc_ipv6_cidr_block = null        # Default: null - Custom IPv6 CIDR block
  main_vpc_ipv6_cidr_block_network_border_group = null  # Default: null - Network border group for IPv6

  # Main VPC Subnet Configuration
  main_public_subnet_map_public_ip_on_launch = true    # Default: true - Auto-assign public IPs to public subnets
  main_public_subnet_assign_ipv6_address_on_creation = false  # Default: false - Auto-assign IPv6 addresses to public subnets
  main_public_subnet_ipv6_cidr_blocks = null           # Default: null - IPv6 CIDR blocks for public subnets
  main_private_subnet_map_public_ip_on_launch = false  # Default: false - Don't auto-assign public IPs to private subnets
  main_private_subnet_assign_ipv6_address_on_creation = false  # Default: false - Auto-assign IPv6 addresses to private subnets
  main_private_subnet_ipv6_cidr_blocks = null          # Default: null - IPv6 CIDR blocks for private subnets

  # Production VPC Advanced Configuration (disabled for basic example)
  production_vpc_enable_dns_hostnames = true   # Default: true - Enable DNS hostnames for instances
  production_vpc_enable_dns_support = true     # Default: true - Enable DNS support for the VPC
  production_vpc_assign_generated_ipv6_cidr_block = false  # Default: false - Assign IPv6 CIDR block
  production_vpc_ipv6_cidr_block = null        # Default: null - Custom IPv6 CIDR block
  production_vpc_ipv6_cidr_block_network_border_group = null  # Default: null - Network border group for IPv6

  # Production VPC Subnet Configuration (disabled for basic example)
  production_public_subnet_map_public_ip_on_launch = true    # Default: true - Auto-assign public IPs to public subnets
  production_public_subnet_assign_ipv6_address_on_creation = false  # Default: false - Auto-assign IPv6 addresses to public subnets
  production_public_subnet_ipv6_cidr_blocks = null           # Default: null - IPv6 CIDR blocks for public subnets
  production_private_subnet_map_public_ip_on_launch = false  # Default: false - Don't auto-assign public IPs to private subnets
  production_private_subnet_assign_ipv6_address_on_creation = false  # Default: false - Auto-assign IPv6 addresses to private subnets
  production_private_subnet_ipv6_cidr_blocks = null          # Default: null - IPv6 CIDR blocks for private subnets

  # Development VPC Advanced Configuration (disabled for basic example)
  development_vpc_enable_dns_hostnames = true   # Default: true - Enable DNS hostnames for instances
  development_vpc_enable_dns_support = true     # Default: true - Enable DNS support for the VPC
  development_vpc_assign_generated_ipv6_cidr_block = false  # Default: false - Assign IPv6 CIDR block
  development_vpc_ipv6_cidr_block = null        # Default: null - Custom IPv6 CIDR block
  development_vpc_ipv6_cidr_block_network_border_group = null  # Default: null - Network border group for IPv6

  # Development VPC Subnet Configuration (disabled for basic example)
  development_public_subnet_map_public_ip_on_launch = true    # Default: true - Auto-assign public IPs to public subnets
  development_public_subnet_assign_ipv6_address_on_creation = false  # Default: false - Auto-assign IPv6 addresses to public subnets
  development_public_subnet_ipv6_cidr_blocks = null           # Default: null - IPv6 CIDR blocks for public subnets
  development_private_subnet_map_public_ip_on_launch = false  # Default: false - Don't auto-assign public IPs to private subnets
  development_private_subnet_assign_ipv6_address_on_creation = false  # Default: false - Auto-assign IPv6 addresses to private subnets
  development_private_subnet_ipv6_cidr_blocks = null          # Default: null - IPv6 CIDR blocks for private subnets

  # NAT Gateway Configuration
  enable_nat_gateway = true  # Default: true - Enable NAT Gateway for private subnets

  # Transit Gateway Configuration
  create_transit_gateway = false  # Default: true - Create Transit Gateway (disabled for basic example)

  # Transit Gateway Advanced Configuration (disabled for basic example)
  transit_gateway_default_route_table_association = "enable"  # Default: enable - Enable default route table association
  transit_gateway_default_route_table_propagation = "enable"  # Default: enable - Enable default route table propagation
  transit_gateway_auto_accept_shared_attachments = "enable"   # Default: enable - Auto-accept shared attachments
  transit_gateway_asn = 64512                                 # Default: 64512 - Amazon side ASN
  transit_gateway_dns_support = "enable"                      # Default: enable - Enable DNS support
  transit_gateway_vpn_ecmp_support = "enable"                 # Default: enable - Enable VPN ECMP support
  transit_gateway_multicast_support = "disable"               # Default: disable - Enable multicast support
  transit_gateway_appliance_mode_support = "disable"          # Default: disable - Enable appliance mode support
  transit_gateway_attachment_dns_support = "enable"           # Default: enable - Enable DNS support for attachments
  transit_gateway_attachment_ipv6_support = "disable"         # Default: disable - Enable IPv6 support for attachments

  # VPN Configuration
  create_vpn = false  # Default: false - Create Site-to-Site VPN connection (disabled for basic example)

  # VPN Advanced Configuration (disabled for basic example)
  customer_gateway_bgp_asn = 65000  # Default: 65000 - BGP ASN for the customer gateway
  customer_gateway_ip = ""          # Default: "" - IP address of the customer gateway
  vpn_static_routes_only = true     # Default: true - Use static routes only for VPN

  # Load Balancer Configuration
  create_alb = false  # Default: false - Create Application Load Balancer (disabled for basic example)
  create_nlb = false  # Default: false - Create Network Load Balancer (disabled for basic example)

  # Load Balancer Advanced Configuration (disabled for basic example)
  alb_internal = false              # Default: false - Whether the ALB is internal (private)
  nlb_internal = false              # Default: false - Whether the NLB is internal (private)
  alb_deletion_protection = false   # Default: false - Enable deletion protection for ALB
  nlb_deletion_protection = false   # Default: false - Enable deletion protection for NLB
  alb_target_port = 80              # Default: 80 - Target port for ALB
  nlb_target_port = 80              # Default: 80 - Target port for NLB
  alb_health_check_path = "/health" # Default: /health - Health check path for ALB

  # VPC Endpoints Configuration
  create_vpc_endpoints = false  # Default: false - Create VPC endpoints (disabled for basic example)

  # Common Tags
  common_tags = {
    Environment = "dev"      # Default: dev - Environment tag
    Project     = "basic-example"  # Default: enterprise-infrastructure - Project tag
    Owner       = "devops-team"    # Default: DevOps Team - Owner tag
    CostCenter  = "IT-001"         # Default: IT-001 - Cost center tag
    ManagedBy   = "Terraform"      # Additional tag for resource management
    Backup      = "true"           # Additional tag for backup policies
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