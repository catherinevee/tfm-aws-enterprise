# AWS Enterprise Multi-VPC Infrastructure Module

A comprehensive Terraform module for creating enterprise-grade AWS infrastructure with multiple VPCs, Transit Gateway connectivity, Site-to-Site VPN, load balancers, and VPC endpoints.

## 🏗️ Architecture Overview

This module creates a complete enterprise networking infrastructure with the following components:

- **Multi-VPC Architecture**: Main, Production, and Development VPCs
- **Transit Gateway**: Centralized VPC connectivity and routing
- **Site-to-Site VPN**: Hybrid connectivity to on-premises networks
- **Load Balancers**: Application Load Balancer (ALB) and Network Load Balancer (NLB)
- **VPC Endpoints**: Private connectivity to AWS services
- **NAT Gateways**: Outbound internet access for private subnets
- **Security Groups**: Proper network segmentation and security

## 📋 Features

### ✅ Multi-VPC Support
- Create up to 3 VPCs (Main, Production, Development)
- Configurable CIDR blocks for each VPC
- Public and private subnets across multiple availability zones
- Independent internet gateways and NAT gateways

### ✅ Transit Gateway Integration
- Centralized VPC connectivity
- Automatic route propagation
- Shared attachments support
- Custom route table management

### ✅ VPN Connectivity
- Site-to-Site VPN with customer gateway
- BGP routing support
- Static and dynamic routing options
- High availability with dual tunnels

### ✅ Load Balancing
- Application Load Balancer (ALB) for HTTP/HTTPS traffic
- Network Load Balancer (NLB) for TCP/UDP traffic
- Configurable target groups and health checks
- Internal and external load balancer options

### ✅ VPC Endpoints
- S3 and DynamoDB Gateway endpoints
- EC2, ECR, and ECR DKR Interface endpoints
- Private DNS resolution
- Security group integration

### ✅ Security & Compliance
- Proper network segmentation
- Security groups with least-privilege access
- Resource tagging for cost management
- Encryption in transit and at rest

## 🚀 Quick Start

### Basic Usage

```hcl
module "enterprise_infrastructure" {
  source = "./tfm-aws-enterprise"

  environment = "dev"
  
  # Enable main VPC only
  create_main_vpc = true
  
  # Enable Transit Gateway
  create_transit_gateway = true
  
  # Enable VPC endpoints
  create_vpc_endpoints = true
  
  # Enable load balancers
  create_alb = true
  create_nlb = true
  
  common_tags = {
    Environment = "dev"
    Project     = "my-project"
    Owner       = "devops-team"
  }
}
```

### Advanced Usage

```hcl
module "enterprise_infrastructure" {
  source = "./tfm-aws-enterprise"

  environment = "prod"
  
  # Create all VPCs
  create_main_vpc        = true
  create_production_vpc  = true
  create_development_vpc = true
  
  # Custom CIDR blocks
  main_vpc_cidr         = "10.0.0.0/16"
  production_vpc_cidr   = "10.1.0.0/16"
  development_vpc_cidr  = "10.2.0.0/16"
  
  # Custom subnets
  main_public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  main_private_subnets = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  
  # Transit Gateway
  create_transit_gateway = true
  
  # VPN Configuration
  create_vpn              = true
  customer_gateway_ip     = "203.0.113.1"
  customer_gateway_bgp_asn = 65000
  
  # Load Balancers
  create_alb = true
  create_nlb = true
  
  alb_internal = false
  nlb_internal = true
  
  # VPC Endpoints
  create_vpc_endpoints = true
  
  # NAT Gateways
  enable_nat_gateway = true
  
  common_tags = {
    Environment = "production"
    Project     = "enterprise-app"
    Owner       = "infrastructure-team"
    CostCenter  = "IT-001"
  }
}
```

## 📖 Input Variables

### General Configuration

| Variable | Description | Type | Default | Required |
|----------|-------------|------|---------|:--------:|
| `environment` | Environment name (dev, staging, prod, test) | `string` | `"dev"` | no |
| `common_tags` | Common tags to apply to all resources | `map(string)` | `{}` | no |

### VPC Configuration

| Variable | Description | Type | Default | Required |
|----------|-------------|------|---------|:--------:|
| `create_main_vpc` | Whether to create the main VPC | `bool` | `true` | no |
| `create_production_vpc` | Whether to create the production VPC | `bool` | `false` | no |
| `create_development_vpc` | Whether to create the development VPC | `bool` | `false` | no |
| `main_vpc_cidr` | CIDR block for the main VPC | `string` | `"10.0.0.0/16"` | no |
| `production_vpc_cidr` | CIDR block for the production VPC | `string` | `"10.1.0.0/16"` | no |
| `development_vpc_cidr` | CIDR block for the development VPC | `string` | `"10.2.0.0/16"` | no |

### Subnet Configuration

| Variable | Description | Type | Default | Required |
|----------|-------------|------|---------|:--------:|
| `main_public_subnets` | List of public subnet CIDR blocks for main VPC | `list(string)` | `["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]` | no |
| `main_private_subnets` | List of private subnet CIDR blocks for main VPC | `list(string)` | `["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]` | no |
| `production_public_subnets` | List of public subnet CIDR blocks for production VPC | `list(string)` | `["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]` | no |
| `production_private_subnets` | List of private subnet CIDR blocks for production VPC | `list(string)` | `["10.1.11.0/24", "10.1.12.0/24", "10.1.13.0/24"]` | no |
| `development_public_subnets` | List of public subnet CIDR blocks for development VPC | `list(string)` | `["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]` | no |
| `development_private_subnets` | List of private subnet CIDR blocks for development VPC | `list(string)` | `["10.2.11.0/24", "10.2.12.0/24", "10.2.13.0/24"]` | no |

### Transit Gateway

| Variable | Description | Type | Default | Required |
|----------|-------------|------|---------|:--------:|
| `create_transit_gateway` | Whether to create Transit Gateway | `bool` | `true` | no |

### VPN Configuration

| Variable | Description | Type | Default | Required |
|----------|-------------|------|---------|:--------:|
| `create_vpn` | Whether to create Site-to-Site VPN | `bool` | `false` | no |
| `customer_gateway_ip` | IP address of the customer gateway | `string` | `""` | no |
| `customer_gateway_bgp_asn` | BGP ASN for the customer gateway | `number` | `65000` | no |
| `vpn_static_routes_only` | Whether to use static routes only | `bool` | `true` | no |

### Load Balancers

| Variable | Description | Type | Default | Required |
|----------|-------------|------|---------|:--------:|
| `create_alb` | Whether to create Application Load Balancer | `bool` | `false` | no |
| `create_nlb` | Whether to create Network Load Balancer | `bool` | `false` | no |
| `alb_internal` | Whether the ALB is internal | `bool` | `false` | no |
| `nlb_internal` | Whether the NLB is internal | `bool` | `false` | no |
| `alb_deletion_protection` | Whether to enable ALB deletion protection | `bool` | `false` | no |
| `nlb_deletion_protection` | Whether to enable NLB deletion protection | `bool` | `false` | no |
| `alb_target_port` | Target port for ALB target group | `number` | `80` | no |
| `nlb_target_port` | Target port for NLB target group | `number` | `80` | no |
| `alb_health_check_path` | Health check path for ALB | `string` | `"/"` | no |

### VPC Endpoints

| Variable | Description | Type | Default | Required |
|----------|-------------|------|---------|:--------:|
| `create_vpc_endpoints` | Whether to create VPC endpoints | `bool` | `false` | no |

### NAT Gateway

| Variable | Description | Type | Default | Required |
|----------|-------------|------|---------|:--------:|
| `enable_nat_gateway` | Whether to enable NAT Gateway | `bool` | `true` | no |

## 📤 Outputs

### VPC Outputs

| Output | Description |
|--------|-------------|
| `main_vpc_id` | ID of the main VPC |
| `main_vpc_cidr_block` | CIDR block of the main VPC |
| `production_vpc_id` | ID of the production VPC |
| `development_vpc_id` | ID of the development VPC |

### Subnet Outputs

| Output | Description |
|--------|-------------|
| `main_public_subnet_ids` | IDs of the main VPC public subnets |
| `main_private_subnet_ids` | IDs of the main VPC private subnets |
| `production_public_subnet_ids` | IDs of the production VPC public subnets |
| `development_private_subnet_ids` | IDs of the development VPC private subnets |

### Transit Gateway Outputs

| Output | Description |
|--------|-------------|
| `transit_gateway_id` | ID of the Transit Gateway |
| `transit_gateway_arn` | ARN of the Transit Gateway |
| `main_vpc_tgw_attachment_id` | ID of the main VPC Transit Gateway attachment |

### VPN Outputs

| Output | Description |
|--------|-------------|
| `customer_gateway_id` | ID of the Customer Gateway |
| `vpn_gateway_id` | ID of the VPN Gateway |
| `vpn_connection_id` | ID of the VPN Connection |
| `vpn_connection_tunnel1_address` | Tunnel 1 address |
| `vpn_connection_tunnel2_address` | Tunnel 2 address |

### Load Balancer Outputs

| Output | Description |
|--------|-------------|
| `alb_id` | ID of the Application Load Balancer |
| `alb_dns_name` | DNS name of the ALB |
| `nlb_id` | ID of the Network Load Balancer |
| `nlb_dns_name` | DNS name of the NLB |
| `alb_target_group_arn` | ARN of the ALB target group |
| `nlb_target_group_arn` | ARN of the NLB target group |

### VPC Endpoints Outputs

| Output | Description |
|--------|-------------|
| `s3_vpc_endpoint_id` | ID of the S3 VPC endpoint |
| `dynamodb_vpc_endpoint_id` | ID of the DynamoDB VPC endpoint |
| `ec2_vpc_endpoint_id` | ID of the EC2 VPC endpoint |
| `ecr_vpc_endpoint_id` | ID of the ECR VPC endpoint |

### Summary Outputs

| Output | Description |
|--------|-------------|
| `vpc_summary` | Summary of all VPCs created |
| `load_balancer_summary` | Summary of load balancers created |
| `connectivity_summary` | Summary of connectivity resources |

## 🔧 Usage Examples

### Example 1: Basic Single VPC

```hcl
module "basic_infrastructure" {
  source = "./tfm-aws-enterprise"

  environment = "dev"
  
  create_main_vpc = true
  create_production_vpc = false
  create_development_vpc = false
  
  create_transit_gateway = false
  create_vpc_endpoints = false
  create_alb = false
  create_nlb = false
  
  common_tags = {
    Environment = "dev"
    Project     = "basic-app"
  }
}
```

### Example 2: Multi-VPC with Transit Gateway

```hcl
module "multi_vpc_infrastructure" {
  source = "./tfm-aws-enterprise"

  environment = "prod"
  
  # Create all VPCs
  create_main_vpc        = true
  create_production_vpc  = true
  create_development_vpc = true
  
  # Transit Gateway for VPC connectivity
  create_transit_gateway = true
  
  # VPC Endpoints for private AWS service access
  create_vpc_endpoints = true
  
  # Load balancers
  create_alb = true
  create_nlb = true
  
  alb_internal = false
  nlb_internal = true
  
  common_tags = {
    Environment = "production"
    Project     = "enterprise-platform"
    Owner       = "platform-team"
  }
}
```

### Example 3: Hybrid Cloud with VPN

```hcl
module "hybrid_infrastructure" {
  source = "./tfm-aws-enterprise"

  environment = "prod"
  
  create_main_vpc = true
  create_transit_gateway = true
  
  # VPN Configuration
  create_vpn = true
  customer_gateway_ip = "203.0.113.1"
  customer_gateway_bgp_asn = 65000
  vpn_static_routes_only = false
  
  # Load balancers
  create_alb = true
  alb_internal = false
  
  # VPC endpoints
  create_vpc_endpoints = true
  
  common_tags = {
    Environment = "production"
    Project     = "hybrid-cloud"
    NetworkType = "hybrid"
  }
}
```

## 🛠️ Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | ~> 5.0 |

## 🔒 Security Considerations

### Network Security
- All VPCs use private subnets for sensitive resources
- Security groups implement least-privilege access
- VPC endpoints provide private AWS service access
- NAT gateways control outbound internet access

### VPN Security
- Site-to-Site VPN uses IPsec encryption
- BGP routing for dynamic route updates
- Dual tunnel configuration for high availability
- Customer gateway authentication

### Load Balancer Security
- Security groups restrict access to load balancers
- Internal load balancers for private applications
- Health checks ensure only healthy targets receive traffic
- Deletion protection prevents accidental removal

## 💰 Cost Optimization

### NAT Gateway Costs
- NAT gateways incur hourly charges and data processing fees
- Consider using NAT instances for development environments
- Use VPC endpoints to reduce NAT gateway traffic

### Transit Gateway Costs
- Transit Gateway has hourly charges and data processing fees
- VPC attachments have hourly charges
- Consider VPC peering for simple connectivity needs

### Load Balancer Costs
- ALB and NLB have hourly charges and data processing fees
- Use internal load balancers when possible
- Consider using Application Load Balancer for HTTP/HTTPS traffic only

## 🧪 Testing

### Prerequisites
- AWS CLI configured with appropriate permissions
- Terraform >= 1.0 installed
- Access to AWS account with required permissions

### Running Tests

```bash
# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Plan deployment
terraform plan

# Apply configuration
terraform apply

# Test connectivity
# - Verify VPC connectivity
# - Test load balancer health checks
# - Validate VPN connection (if enabled)
# - Check VPC endpoint connectivity

# Clean up
terraform destroy
```

## 📝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This module is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## 🆘 Support

For support and questions:
- Create an issue in the repository
- Check the [Terraform documentation](https://www.terraform.io/docs)
- Review AWS service documentation

## 🔄 Version History

- **v1.0.0**: Initial release with multi-VPC, Transit Gateway, VPN, load balancers, and VPC endpoints