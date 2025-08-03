# AWS Enterprise Multi-VPC Infrastructure Terraform Module

A comprehensive Terraform module for deploying enterprise-grade multi-VPC AWS infrastructure with Transit Gateway connectivity, VPN connections, load balancers, and VPC endpoints.

## 🏗️ Architecture Overview

This module provides a complete enterprise infrastructure solution including:

- **Multi-VPC Architecture**: Separate VPCs for main, production, and development environments
- **Transit Gateway**: Centralized connectivity hub for all VPCs
- **VPN Connectivity**: Site-to-Site VPN connections for hybrid cloud
- **Load Balancing**: Application and Network Load Balancers
- **VPC Endpoints**: Private connectivity to AWS services
- **Advanced Networking**: IPv6 support, custom DNS settings, and flexible subnet configurations

## 🚀 Features

### Multi-VPC Architecture
- ✅ Separate VPCs for main, production, and development environments
- ✅ Configurable CIDR blocks for each VPC
- ✅ Advanced DNS and IPv6 support for each VPC
- ✅ Flexible subnet configurations with public/private subnets

### Transit Gateway Connectivity
- ✅ Centralized Transit Gateway for VPC connectivity
- ✅ Configurable route table association and propagation
- ✅ Advanced features: DNS support, VPN ECMP, multicast support
- ✅ Appliance mode and IPv6 support for VPC attachments

### VPN Connectivity
- ✅ Site-to-Site VPN connections
- ✅ Configurable BGP ASN and static routes
- ✅ Customer gateway management

### Load Balancing
- ✅ Application Load Balancer (ALB) with health checks
- ✅ Network Load Balancer (NLB) for TCP/UDP traffic
- ✅ Configurable internal/external load balancers
- ✅ Deletion protection and target group settings

### VPC Endpoints
- ✅ S3 and DynamoDB Gateway endpoints
- ✅ EC2, ECR, and ECR DKR Interface endpoints
- ✅ Private DNS and security group management

### Advanced Networking
- ✅ IPv6 support for VPCs and subnets
- ✅ Custom DNS hostnames and support settings
- ✅ Flexible public IP assignment policies
- ✅ NAT Gateway configuration per VPC

## 📋 Prerequisites

- Terraform >= 1.0
- AWS Provider >= 5.0
- AWS CLI configured with appropriate permissions
- For VPN: Customer gateway IP address and BGP ASN

## 🔧 Usage

### Basic Usage

```hcl
module "enterprise_infrastructure" {
  source = "./tfm-aws-enterprise"

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

  common_tags = {
    Environment = "dev"
    Project     = "basic-example"
    Owner       = "devops-team"
    CostCenter  = "IT-001"
  }
}
```

### Advanced Configuration

This module provides extensive customization options for all resources. Here are some key configuration areas:

#### VPC Configuration
```hcl
# Main VPC Advanced Settings
main_vpc_enable_dns_hostnames = true                    # Enable DNS hostnames for instances
main_vpc_enable_dns_support = true                      # Enable DNS support for the VPC
main_vpc_assign_generated_ipv6_cidr_block = false       # Assign IPv6 CIDR block
main_vpc_ipv6_cidr_block = null                        # Custom IPv6 CIDR block
main_vpc_ipv6_cidr_block_network_border_group = null   # Network border group for IPv6
```

#### Subnet Configuration
```hcl
# Main VPC Subnet Settings
main_public_subnet_map_public_ip_on_launch = true       # Auto-assign public IPs to public subnets
main_public_subnet_assign_ipv6_address_on_creation = false  # Auto-assign IPv6 addresses
main_public_subnet_ipv6_cidr_blocks = null             # IPv6 CIDR blocks for public subnets
main_private_subnet_map_public_ip_on_launch = false    # Don't auto-assign public IPs to private subnets
main_private_subnet_assign_ipv6_address_on_creation = false # Auto-assign IPv6 addresses
main_private_subnet_ipv6_cidr_blocks = null            # IPv6 CIDR blocks for private subnets
```

#### Transit Gateway Configuration
```hcl
# Transit Gateway Settings
transit_gateway_default_route_table_association = "enable"  # Enable default route table association
transit_gateway_default_route_table_propagation = "enable"  # Enable default route table propagation
transit_gateway_auto_accept_shared_attachments = "enable"   # Auto-accept shared attachments
transit_gateway_asn = 64512                                # Amazon side ASN
transit_gateway_dns_support = "enable"                     # Enable DNS support
transit_gateway_vpn_ecmp_support = "enable"                # Enable VPN ECMP support
transit_gateway_multicast_support = "disable"              # Enable multicast support
```

#### Load Balancer Configuration
```hcl
# Load Balancer Settings
create_alb = true                                         # Create Application Load Balancer
create_nlb = true                                         # Create Network Load Balancer
alb_internal = false                                      # Internet-facing ALB
nlb_internal = false                                      # Internet-facing NLB
alb_deletion_protection = false                          # Enable deletion protection for ALB
nlb_deletion_protection = false                          # Enable deletion protection for NLB
alb_target_port = 80                                     # Target port for ALB
nlb_target_port = 80                                     # Target port for NLB
alb_health_check_path = "/health"                        # Health check path for ALB
```

#### VPN Configuration
```hcl
# VPN Settings
create_vpn = true                                         # Create Site-to-Site VPN connection
customer_gateway_bgp_asn = 65000                         # BGP ASN for the customer gateway
customer_gateway_ip = "203.0.113.1"                      # IP address of the customer gateway
vpn_static_routes_only = true                            # Use static routes only for VPN
```

## 📖 Inputs

### General Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment | Environment name (e.g., dev, staging, prod) | `string` | `"dev"` | no |
| common_tags | Common tags to apply to all resources | `map(string)` | `{}` | no |

### VPC Configuration Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_main_vpc | Whether to create the main VPC | `bool` | `true` | no |
| create_production_vpc | Whether to create the production VPC | `bool` | `false` | no |
| create_development_vpc | Whether to create the development VPC | `bool` | `false` | no |
| main_vpc_cidr | CIDR block for the main VPC | `string` | `"10.0.0.0/16"` | no |
| production_vpc_cidr | CIDR block for the production VPC | `string` | `"10.1.0.0/16"` | no |
| development_vpc_cidr | CIDR block for the development VPC | `string` | `"10.2.0.0/16"` | no |

### VPC Advanced Configuration
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| main_vpc_enable_dns_hostnames | Enable DNS hostnames in the main VPC | `bool` | `true` | no |
| main_vpc_enable_dns_support | Enable DNS support in the main VPC | `bool` | `true` | no |
| main_vpc_assign_generated_ipv6_cidr_block | Assign generated IPv6 CIDR block to the main VPC | `bool` | `false` | no |
| main_vpc_ipv6_cidr_block | IPv6 CIDR block for the main VPC | `string` | `null` | no |
| main_vpc_ipv6_cidr_block_network_border_group | IPv6 CIDR block network border group for the main VPC | `string` | `null` | no |

### Subnet Configuration Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| main_public_subnets | List of public subnet CIDR blocks for main VPC | `list(string)` | `["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]` | no |
| main_private_subnets | List of private subnet CIDR blocks for main VPC | `list(string)` | `["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]` | no |
| production_public_subnets | List of public subnet CIDR blocks for production VPC | `list(string)` | `["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]` | no |
| production_private_subnets | List of private subnet CIDR blocks for production VPC | `list(string)` | `["10.1.10.0/24", "10.1.11.0/24", "10.1.12.0/24"]` | no |
| development_public_subnets | List of public subnet CIDR blocks for development VPC | `list(string)` | `["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]` | no |
| development_private_subnets | List of private subnet CIDR blocks for development VPC | `list(string)` | `["10.2.10.0/24", "10.2.11.0/24", "10.2.12.0/24"]` | no |

### Subnet Advanced Configuration
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| main_public_subnet_map_public_ip_on_launch | Map public IP on launch for main VPC public subnets | `bool` | `true` | no |
| main_public_subnet_assign_ipv6_address_on_creation | Assign IPv6 address on creation for main VPC public subnets | `bool` | `false` | no |
| main_public_subnet_ipv6_cidr_blocks | IPv6 CIDR blocks for main VPC public subnets | `list(string)` | `null` | no |
| main_private_subnet_map_public_ip_on_launch | Map public IP on launch for main VPC private subnets | `bool` | `false` | no |
| main_private_subnet_assign_ipv6_address_on_creation | Assign IPv6 address on creation for main VPC private subnets | `bool` | `false` | no |
| main_private_subnet_ipv6_cidr_blocks | IPv6 CIDR blocks for main VPC private subnets | `list(string)` | `null` | no |

### Transit Gateway Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_transit_gateway | Whether to create Transit Gateway for VPC connectivity | `bool` | `true` | no |
| transit_gateway_default_route_table_association | Enable default route table association for Transit Gateway | `string` | `"enable"` | no |
| transit_gateway_default_route_table_propagation | Enable default route table propagation for Transit Gateway | `string` | `"enable"` | no |
| transit_gateway_auto_accept_shared_attachments | Auto-accept shared attachments for Transit Gateway | `string` | `"enable"` | no |
| transit_gateway_asn | Amazon side ASN for Transit Gateway | `number` | `64512` | no |
| transit_gateway_dns_support | Enable DNS support for Transit Gateway | `string` | `"enable"` | no |
| transit_gateway_vpn_ecmp_support | Enable VPN ECMP support for Transit Gateway | `string` | `"enable"` | no |
| transit_gateway_multicast_support | Enable multicast support for Transit Gateway | `string` | `"disable"` | no |
| transit_gateway_appliance_mode_support | Enable appliance mode support for Transit Gateway VPC attachments | `string` | `"disable"` | no |
| transit_gateway_attachment_dns_support | Enable DNS support for Transit Gateway VPC attachments | `string` | `"enable"` | no |
| transit_gateway_attachment_ipv6_support | Enable IPv6 support for Transit Gateway VPC attachments | `string` | `"disable"` | no |

### VPN Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_vpn | Whether to create Site-to-Site VPN connection | `bool` | `false` | no |
| customer_gateway_bgp_asn | BGP ASN for the customer gateway | `number` | `65000` | no |
| customer_gateway_ip | IP address of the customer gateway | `string` | `""` | no |
| vpn_static_routes_only | Whether to use static routes only for VPN | `bool` | `true` | no |

### Load Balancer Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_alb | Whether to create Application Load Balancer | `bool` | `false` | no |
| create_nlb | Whether to create Network Load Balancer | `bool` | `false` | no |
| alb_internal | Whether the ALB is internal (private) | `bool` | `false` | no |
| nlb_internal | Whether the NLB is internal (private) | `bool` | `false` | no |
| alb_deletion_protection | Whether to enable deletion protection for ALB | `bool` | `false` | no |
| nlb_deletion_protection | Whether to enable deletion protection for NLB | `bool` | `false` | no |
| alb_target_port | Target port for ALB | `number` | `80` | no |
| nlb_target_port | Target port for NLB | `number` | `80` | no |
| alb_health_check_path | Health check path for ALB | `string` | `"/health"` | no |

### VPC Endpoints Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_vpc_endpoints | Whether to create VPC endpoints | `bool` | `false` | no |

### NAT Gateway Variables
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enable_nat_gateway | Whether to enable NAT Gateway for private subnets | `bool` | `true` | no |

## 📤 Outputs

| Name | Description |
|------|-------------|
| main_vpc_id | ID of the main VPC |
| main_public_subnet_ids | IDs of the main VPC public subnets |
| main_private_subnet_ids | IDs of the main VPC private subnets |
| production_vpc_id | ID of the production VPC |
| production_public_subnet_ids | IDs of the production VPC public subnets |
| production_private_subnet_ids | IDs of the production VPC private subnets |
| development_vpc_id | ID of the development VPC |
| development_public_subnet_ids | IDs of the development VPC public subnets |
| development_private_subnet_ids | IDs of the development VPC private subnets |
| transit_gateway_id | ID of the Transit Gateway |
| transit_gateway_arn | ARN of the Transit Gateway |
| vpn_gateway_id | ID of the VPN Gateway |
| vpn_connection_id | ID of the VPN connection |
| alb_id | ID of the Application Load Balancer |
| alb_arn | ARN of the Application Load Balancer |
| alb_dns_name | DNS name of the Application Load Balancer |
| nlb_id | ID of the Network Load Balancer |
| nlb_arn | ARN of the Network Load Balancer |
| nlb_dns_name | DNS name of the Network Load Balancer |
| vpc_summary | Summary of VPCs created |

## 🔧 Examples

### Basic Example
See the [basic example](./examples/basic/) for a minimal configuration with essential features enabled.

### Advanced Example
See the [advanced example](./examples/advanced/) for a comprehensive configuration with all features enabled.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

For support and questions, please open an issue in the GitHub repository.