# AWS Enterprise Multi-VPC Infrastructure - Customization Guide

This guide provides comprehensive documentation for customizing the AWS Enterprise Multi-VPC Infrastructure Terraform module. Each section includes detailed explanations of variables, their default values, and practical examples.

## Table of Contents

1. [Basic Configuration](#basic-configuration)
2. [VPC Configuration](#vpc-configuration)
3. [Subnet Configuration](#subnet-configuration)
4. [NAT Gateway Configuration](#nat-gateway-configuration)
5. [Transit Gateway Configuration](#transit-gateway-configuration)
6. [VPN Configuration](#vpn-configuration)
7. [Load Balancer Configuration](#load-balancer-configuration)
8. [VPC Endpoints Configuration](#vpc-endpoints-configuration)
9. [Security Configuration](#security-configuration)
10. [Tagging Strategy](#tagging-strategy)
11. [Usage Examples](#usage-examples)
12. [Best Practices](#best-practices)
13. [Troubleshooting](#troubleshooting)

## Basic Configuration

### Environment and Project Settings

```hcl
# Basic Configuration
environment = "dev"  # Default: dev - Environment name for resource naming

# Common Tags
common_tags = {
  Environment = "dev"      # Default: dev - Environment tag
  Project     = "my-project"  # Default: enterprise-infrastructure - Project tag
  Owner       = "devops-team"    # Default: DevOps Team - Owner tag
  CostCenter  = "IT-001"         # Default: IT-001 - Cost center tag
  ManagedBy   = "Terraform"      # Additional tag for resource management
  Backup      = "true"           # Additional tag for backup policies
}
```

**Variables:**
- `environment` (string, default: "dev"): Environment name used for resource naming
- `common_tags` (map(string), default: {}): Common tags applied to all resources

## VPC Configuration

### VPC Creation Control

```hcl
# VPC Creation Control
create_main_vpc        = true   # Default: true - Create main VPC
create_production_vpc  = false  # Default: false - Create production VPC
create_development_vpc = false  # Default: false - Create development VPC
```

**Variables:**
- `create_main_vpc` (bool, default: true): Whether to create the main VPC
- `create_production_vpc` (bool, default: false): Whether to create the production VPC
- `create_development_vpc` (bool, default: false): Whether to create the development VPC

### VPC CIDR Blocks

```hcl
# VPC CIDR Blocks
main_vpc_cidr         = "10.0.0.0/16"  # Default: 10.0.0.0/16 - Main VPC CIDR block
production_vpc_cidr   = "10.1.0.0/16"  # Default: 10.1.0.0/16 - Production VPC CIDR block
development_vpc_cidr  = "10.2.0.0/16"  # Default: 10.2.0.0/16 - Development VPC CIDR block
```

**Variables:**
- `main_vpc_cidr` (string, default: "10.0.0.0/16"): CIDR block for the main VPC
- `production_vpc_cidr` (string, default: "10.1.0.0/16"): CIDR block for the production VPC
- `development_vpc_cidr` (string, default: "10.2.0.0/16"): CIDR block for the development VPC

### VPC Advanced Configuration

#### Main VPC Advanced Settings

```hcl
# Main VPC Advanced Configuration
main_vpc_enable_dns_hostnames = true                    # Default: true - Enable DNS hostnames for instances
main_vpc_enable_dns_support = true                      # Default: true - Enable DNS support for the VPC
main_vpc_assign_generated_ipv6_cidr_block = false       # Default: false - Assign IPv6 CIDR block
main_vpc_ipv6_cidr_block = null                        # Default: null - Custom IPv6 CIDR block
main_vpc_ipv6_cidr_block_network_border_group = null   # Default: null - Network border group for IPv6
```

**Variables:**
- `main_vpc_enable_dns_hostnames` (bool, default: true): Enable DNS hostnames for instances
- `main_vpc_enable_dns_support` (bool, default: true): Enable DNS support for the VPC
- `main_vpc_assign_generated_ipv6_cidr_block` (bool, default: false): Assign generated IPv6 CIDR block
- `main_vpc_ipv6_cidr_block` (string, default: null): Custom IPv6 CIDR block
- `main_vpc_ipv6_cidr_block_network_border_group` (string, default: null): Network border group for IPv6

#### Production VPC Advanced Settings

```hcl
# Production VPC Advanced Configuration
production_vpc_enable_dns_hostnames = true              # Default: true - Enable DNS hostnames for instances
production_vpc_enable_dns_support = true                # Default: true - Enable DNS support for the VPC
production_vpc_assign_generated_ipv6_cidr_block = false # Default: false - Assign IPv6 CIDR block
production_vpc_ipv6_cidr_block = null                  # Default: null - Custom IPv6 CIDR block
production_vpc_ipv6_cidr_block_network_border_group = null  # Default: null - Network border group for IPv6
```

#### Development VPC Advanced Settings

```hcl
# Development VPC Advanced Configuration
development_vpc_enable_dns_hostnames = true             # Default: true - Enable DNS hostnames for instances
development_vpc_enable_dns_support = true               # Default: true - Enable DNS support for the VPC
development_vpc_assign_generated_ipv6_cidr_block = false # Default: false - Assign IPv6 CIDR block
development_vpc_ipv6_cidr_block = null                 # Default: null - Custom IPv6 CIDR block
development_vpc_ipv6_cidr_block_network_border_group = null  # Default: null - Network border group for IPv6
```

## Subnet Configuration

### Subnet CIDR Blocks

```hcl
# Main VPC Subnets
main_public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]   # Default: 3 public subnets
main_private_subnets = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"] # Default: 3 private subnets

# Production VPC Subnets
production_public_subnets  = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]   # Default: 3 public subnets
production_private_subnets = ["10.1.10.0/24", "10.1.11.0/24", "10.1.12.0/24"] # Default: 3 private subnets

# Development VPC Subnets
development_public_subnets  = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]   # Default: 3 public subnets
development_private_subnets = ["10.2.10.0/24", "10.2.11.0/24", "10.2.12.0/24"] # Default: 3 private subnets
```

### Subnet Advanced Configuration

#### Main VPC Subnet Settings

```hcl
# Main VPC Public Subnet Settings
main_public_subnet_map_public_ip_on_launch = true       # Default: true - Auto-assign public IPs to public subnets
main_public_subnet_assign_ipv6_address_on_creation = false  # Default: false - Auto-assign IPv6 addresses
main_public_subnet_ipv6_cidr_blocks = null             # Default: null - IPv6 CIDR blocks for public subnets

# Main VPC Private Subnet Settings
main_private_subnet_map_public_ip_on_launch = false    # Default: false - Do not auto-assign public IPs to private subnets
main_private_subnet_assign_ipv6_address_on_creation = false # Default: false - Auto-assign IPv6 addresses
main_private_subnet_ipv6_cidr_blocks = null            # Default: null - IPv6 CIDR blocks for private subnets
```

#### Production VPC Subnet Settings

```hcl
# Production VPC Public Subnet Settings
production_public_subnet_map_public_ip_on_launch = true       # Default: true - Auto-assign public IPs to public subnets
production_public_subnet_assign_ipv6_address_on_creation = false  # Default: false - Auto-assign IPv6 addresses
production_public_subnet_ipv6_cidr_blocks = null             # Default: null - IPv6 CIDR blocks for public subnets

# Production VPC Private Subnet Settings
production_private_subnet_map_public_ip_on_launch = false    # Default: false - Do not auto-assign public IPs to private subnets
production_private_subnet_assign_ipv6_address_on_creation = false # Default: false - Auto-assign IPv6 addresses
production_private_subnet_ipv6_cidr_blocks = null            # Default: null - IPv6 CIDR blocks for private subnets
```

#### Development VPC Subnet Settings

```hcl
# Development VPC Public Subnet Settings
development_public_subnet_map_public_ip_on_launch = true       # Default: true - Auto-assign public IPs to public subnets
development_public_subnet_assign_ipv6_address_on_creation = false  # Default: false - Auto-assign IPv6 addresses
development_public_subnet_ipv6_cidr_blocks = null             # Default: null - IPv6 CIDR blocks for public subnets

# Development VPC Private Subnet Settings
development_private_subnet_map_public_ip_on_launch = false    # Default: false - Do not auto-assign public IPs to private subnets
development_private_subnet_assign_ipv6_address_on_creation = false # Default: false - Auto-assign IPv6 addresses
development_private_subnet_ipv6_cidr_blocks = null            # Default: null - IPv6 CIDR blocks for private subnets
```

## NAT Gateway Configuration

### NAT Gateway Settings

```hcl
# NAT Gateway Configuration
enable_nat_gateway = true  # Default: true - Enable NAT Gateway for private subnets
```

**Variables:**
- `enable_nat_gateway` (bool, default: true): Whether to enable NAT Gateway for private subnets

**Notes:**
- NAT Gateways are created in each public subnet for high availability
- Each NAT Gateway requires an Elastic IP address
- NAT Gateways incur hourly charges and data processing fees

## Transit Gateway Configuration

### Basic Transit Gateway Settings

```hcl
# Transit Gateway Configuration
create_transit_gateway = true  # Default: true - Create Transit Gateway for VPC connectivity
```

**Variables:**
- `create_transit_gateway` (bool, default: true): Whether to create Transit Gateway for VPC connectivity

### Transit Gateway Advanced Settings

```hcl
# Transit Gateway Advanced Configuration
transit_gateway_default_route_table_association = "enable"  # Default: enable - Enable default route table association
transit_gateway_default_route_table_propagation = "enable"  # Default: enable - Enable default route table propagation
transit_gateway_auto_accept_shared_attachments = "enable"   # Default: enable - Auto-accept shared attachments
transit_gateway_asn = 64512                                 # Default: 64512 - Amazon side ASN
transit_gateway_dns_support = "enable"                      # Default: enable - Enable DNS support
transit_gateway_vpn_ecmp_support = "enable"                 # Default: enable - Enable VPN ECMP support
transit_gateway_multicast_support = "disable"               # Default: disable - Enable multicast support
```

**Variables:**
- `transit_gateway_default_route_table_association` (string, default: "enable"): Enable default route table association
- `transit_gateway_default_route_table_propagation` (string, default: "enable"): Enable default route table propagation
- `transit_gateway_auto_accept_shared_attachments` (string, default: "enable"): Auto-accept shared attachments
- `transit_gateway_asn` (number, default: 64512): Amazon side ASN
- `transit_gateway_dns_support` (string, default: "enable"): Enable DNS support
- `transit_gateway_vpn_ecmp_support` (string, default: "enable"): Enable VPN ECMP support
- `transit_gateway_multicast_support` (string, default: "disable"): Enable multicast support

### Transit Gateway VPC Attachment Settings

```hcl
# Transit Gateway VPC Attachment Configuration
transit_gateway_appliance_mode_support = "disable"          # Default: disable - Enable appliance mode support
transit_gateway_attachment_dns_support = "enable"           # Default: enable - Enable DNS support for attachments
transit_gateway_attachment_ipv6_support = "disable"         # Default: disable - Enable IPv6 support for attachments
```

**Variables:**
- `transit_gateway_appliance_mode_support` (string, default: "disable"): Enable appliance mode support for VPC attachments
- `transit_gateway_attachment_dns_support` (string, default: "enable"): Enable DNS support for VPC attachments
- `transit_gateway_attachment_ipv6_support` (string, default: "disable"): Enable IPv6 support for VPC attachments

## VPN Configuration

### Basic VPN Settings

```hcl
# VPN Configuration
create_vpn = false  # Default: false - Create Site-to-Site VPN connection
```

**Variables:**
- `create_vpn` (bool, default: false): Whether to create Site-to-Site VPN connection

### VPN Advanced Settings

```hcl
# VPN Advanced Configuration
customer_gateway_bgp_asn = 65000  # Default: 65000 - BGP ASN for the customer gateway
customer_gateway_ip = ""          # Default: "" - IP address of the customer gateway
vpn_static_routes_only = true     # Default: true - Use static routes only for VPN
```

**Variables:**
- `customer_gateway_bgp_asn` (number, default: 65000): BGP ASN for the customer gateway
- `customer_gateway_ip` (string, default: ""): IP address of the customer gateway
- `vpn_static_routes_only` (bool, default: true): Whether to use static routes only for VPN

## Load Balancer Configuration

### Basic Load Balancer Settings

```hcl
# Load Balancer Configuration
create_alb = false  # Default: false - Create Application Load Balancer
create_nlb = false  # Default: false - Create Network Load Balancer
```

**Variables:**
- `create_alb` (bool, default: false): Whether to create Application Load Balancer
- `create_nlb` (bool, default: false): Whether to create Network Load Balancer

### Load Balancer Advanced Settings

```hcl
# Load Balancer Advanced Configuration
alb_internal = false              # Default: false - Whether the ALB is internal (private)
nlb_internal = false              # Default: false - Whether the NLB is internal (private)
alb_deletion_protection = false   # Default: false - Enable deletion protection for ALB
nlb_deletion_protection = false   # Default: false - Enable deletion protection for NLB
alb_target_port = 80              # Default: 80 - Target port for ALB
nlb_target_port = 80              # Default: 80 - Target port for NLB
alb_health_check_path = "/health" # Default: /health - Health check path for ALB
```

**Variables:**
- `alb_internal` (bool, default: false): Whether the ALB is internal (private)
- `nlb_internal` (bool, default: false): Whether the NLB is internal (private)
- `alb_deletion_protection` (bool, default: false): Enable deletion protection for ALB
- `nlb_deletion_protection` (bool, default: false): Enable deletion protection for NLB
- `alb_target_port` (number, default: 80): Target port for ALB
- `nlb_target_port` (number, default: 80): Target port for NLB
- `alb_health_check_path` (string, default: "/health"): Health check path for ALB

## VPC Endpoints Configuration

### VPC Endpoints Settings

```hcl
# VPC Endpoints Configuration
create_vpc_endpoints = false  # Default: false - Create VPC endpoints
```

**Variables:**
- `create_vpc_endpoints` (bool, default: false): Whether to create VPC endpoints

**Available Endpoints:**
- S3 Gateway Endpoint
- DynamoDB Gateway Endpoint
- EC2 Interface Endpoint
- ECR Interface Endpoint
- ECR DKR Interface Endpoint

## Security Configuration

### Security Groups

The module automatically creates security groups for:
- Application Load Balancer (ALB)
- VPC Endpoints

**ALB Security Group Rules:**
- Ingress: HTTP (80) and HTTPS (443) from anywhere
- Egress: All traffic to anywhere

**VPC Endpoints Security Group Rules:**
- Ingress: HTTPS (443) from VPC CIDR
- Egress: All traffic to anywhere

## Tagging Strategy

### Recommended Tagging

```hcl
common_tags = {
  Environment = "dev"           # Environment (dev, staging, prod)
  Project     = "my-project"    # Project name
  Owner       = "devops-team"   # Team responsible
  CostCenter  = "IT-001"        # Cost center for billing
  ManagedBy   = "Terraform"     # Infrastructure management tool
  Backup      = "true"          # Backup policy
  Security    = "high"          # Security classification
  Compliance  = "SOX"           # Compliance requirements
}
```

## Usage Examples

### Minimal Configuration

```hcl
module "enterprise_infrastructure" {
  source = "./tfm-aws-enterprise"

  environment = "dev"
  
  # Only create main VPC
  create_main_vpc        = true
  create_production_vpc  = false
  create_development_vpc = false
  
  # Disable advanced features
  create_transit_gateway = false
  create_vpn = false
  create_alb = false
  create_nlb = false
  create_vpc_endpoints = false
  
  # Enable NAT Gateway
  enable_nat_gateway = true
  
  common_tags = {
    Environment = "dev"
    Project     = "minimal-example"
    Owner       = "devops-team"
  }
}
```

### Production Configuration

```hcl
module "enterprise_infrastructure" {
  source = "./tfm-aws-enterprise"

  environment = "prod"
  
  # Create all VPCs
  create_main_vpc        = true
  create_production_vpc  = true
  create_development_vpc = true
  
  # Enable all features
  create_transit_gateway = true
  create_vpn = true
  create_alb = true
  create_nlb = true
  create_vpc_endpoints = true
  
  # VPN Configuration
  customer_gateway_ip = "203.0.113.1"
  customer_gateway_bgp_asn = 65000
  
  # Load Balancer Configuration
  alb_internal = false
  nlb_internal = true
  alb_deletion_protection = true
  nlb_deletion_protection = true
  
  # Advanced VPC Settings
  main_vpc_assign_generated_ipv6_cidr_block = true
  production_vpc_assign_generated_ipv6_cidr_block = true
  development_vpc_assign_generated_ipv6_cidr_block = true
  
  common_tags = {
    Environment = "prod"
    Project     = "enterprise-platform"
    Owner       = "platform-team"
    CostCenter  = "IT-001"
    Security    = "high"
    Compliance  = "SOX"
  }
}
```

### Development Configuration

```hcl
module "enterprise_infrastructure" {
  source = "./tfm-aws-enterprise"

  environment = "dev"
  
  # Create main and development VPCs only
  create_main_vpc        = true
  create_production_vpc  = false
  create_development_vpc = true
  
  # Enable basic features
  create_transit_gateway = true
  create_vpn = false
  create_alb = true
  create_nlb = false
  create_vpc_endpoints = true
  
  # Cost optimization for development
  enable_nat_gateway = true
  
  # Load Balancer Configuration
  alb_internal = false
  alb_deletion_protection = false
  
  common_tags = {
    Environment = "dev"
    Project     = "development-platform"
    Owner       = "dev-team"
    CostCenter  = "DEV-001"
  }
}
```

## Best Practices

### 1. CIDR Planning
- Use non-overlapping CIDR blocks for each VPC
- Reserve sufficient IP space for future growth
- Consider IPv6 adoption for future-proofing

### 2. Security
- Use private subnets for sensitive resources
- Implement least-privilege security group rules
- Enable VPC endpoints for private AWS service access
- Use internal load balancers when possible

### 3. Cost Optimization
- Disable NAT Gateways in development environments when possible
- Use VPC endpoints to reduce NAT Gateway traffic
- Consider Transit Gateway costs for multi-VPC architectures
- Implement proper tagging for cost allocation

### 4. High Availability
- Deploy resources across multiple availability zones
- Use multiple NAT Gateways for redundancy
- Implement health checks for load balancers
- Consider VPN redundancy for hybrid connectivity

### 5. Monitoring and Logging
- Enable VPC Flow Logs for network monitoring
- Implement CloudWatch monitoring for load balancers
- Use AWS Config for compliance monitoring
- Set up proper alerting for critical resources

## Troubleshooting

### Common Issues

#### 1. CIDR Block Conflicts
**Problem:** Overlapping CIDR blocks between VPCs
**Solution:** Ensure each VPC uses unique, non-overlapping CIDR blocks

#### 2. NAT Gateway Costs
**Problem:** High costs due to NAT Gateway usage
**Solution:** Use VPC endpoints and consider NAT instances for development

#### 3. Transit Gateway Limits
**Problem:** Hitting Transit Gateway attachment limits
**Solution:** Plan VPC architecture carefully and consider VPC peering for direct connectivity

#### 4. VPN Connection Issues
**Problem:** VPN connection not establishing
**Solution:** Verify customer gateway IP and BGP ASN configuration

#### 5. Load Balancer Health Check Failures
**Problem:** Targets failing health checks
**Solution:** Verify security group rules and target application health

### Debugging Commands

```bash
# Check VPC connectivity
aws ec2 describe-vpcs --vpc-ids vpc-xxxxx

# Verify Transit Gateway attachments
aws ec2 describe-transit-gateway-vpc-attachments

# Check VPN connection status
aws ec2 describe-vpn-connections

# Monitor load balancer health
aws elbv2 describe-target-health --target-group-arn arn:aws:elasticloadbalancing:...

# View VPC Flow Logs
aws logs describe-log-groups --log-group-name-prefix /aws/vpc/flowlogs
```

### Support Resources

- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)
- [AWS Transit Gateway Documentation](https://docs.aws.amazon.com/vpc/latest/tgw/)
- [AWS Load Balancer Documentation](https://docs.aws.amazon.com/elasticloadbalancing/)
- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) 