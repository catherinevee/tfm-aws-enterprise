# =============================================================================
# Enterprise Multi-VPC Infrastructure Outputs
# =============================================================================

# =============================================================================
# VPC Outputs
# =============================================================================

output "main_vpc_id" {
  description = "ID of the main VPC"
  value       = var.create_main_vpc ? aws_vpc.main[0].id : null
}

output "main_vpc_cidr_block" {
  description = "CIDR block of the main VPC"
  value       = var.create_main_vpc ? aws_vpc.main[0].cidr_block : null
}

output "main_vpc_arn" {
  description = "ARN of the main VPC"
  value       = var.create_main_vpc ? aws_vpc.main[0].arn : null
}

output "production_vpc_id" {
  description = "ID of the production VPC"
  value       = var.create_production_vpc ? aws_vpc.production[0].id : null
}

output "production_vpc_cidr_block" {
  description = "CIDR block of the production VPC"
  value       = var.create_production_vpc ? aws_vpc.production[0].cidr_block : null
}

output "production_vpc_arn" {
  description = "ARN of the production VPC"
  value       = var.create_production_vpc ? aws_vpc.production[0].arn : null
}

output "development_vpc_id" {
  description = "ID of the development VPC"
  value       = var.create_development_vpc ? aws_vpc.development[0].id : null
}

output "development_vpc_cidr_block" {
  description = "CIDR block of the development VPC"
  value       = var.create_development_vpc ? aws_vpc.development[0].cidr_block : null
}

output "development_vpc_arn" {
  description = "ARN of the development VPC"
  value       = var.create_development_vpc ? aws_vpc.development[0].arn : null
}

# =============================================================================
# Subnet Outputs
# =============================================================================

output "main_public_subnet_ids" {
  description = "IDs of the main VPC public subnets"
  value       = var.create_main_vpc ? aws_subnet.main_public[*].id : []
}

output "main_private_subnet_ids" {
  description = "IDs of the main VPC private subnets"
  value       = var.create_main_vpc ? aws_subnet.main_private[*].id : []
}

output "production_public_subnet_ids" {
  description = "IDs of the production VPC public subnets"
  value       = var.create_production_vpc ? aws_subnet.production_public[*].id : []
}

output "production_private_subnet_ids" {
  description = "IDs of the production VPC private subnets"
  value       = var.create_production_vpc ? aws_subnet.production_private[*].id : []
}

output "development_public_subnet_ids" {
  description = "IDs of the development VPC public subnets"
  value       = var.create_development_vpc ? aws_subnet.development_public[*].id : []
}

output "development_private_subnet_ids" {
  description = "IDs of the development VPC private subnets"
  value       = var.create_development_vpc ? aws_subnet.development_private[*].id : []
}

# =============================================================================
# Internet Gateway Outputs
# =============================================================================

output "main_internet_gateway_id" {
  description = "ID of the main VPC internet gateway"
  value       = var.create_main_vpc ? aws_internet_gateway.main[0].id : null
}

output "production_internet_gateway_id" {
  description = "ID of the production VPC internet gateway"
  value       = var.create_production_vpc ? aws_internet_gateway.production[0].id : null
}

output "development_internet_gateway_id" {
  description = "ID of the development VPC internet gateway"
  value       = var.create_development_vpc ? aws_internet_gateway.development[0].id : null
}

# =============================================================================
# NAT Gateway Outputs
# =============================================================================

output "main_nat_gateway_ids" {
  description = "IDs of the main VPC NAT gateways"
  value       = var.create_main_vpc && var.enable_nat_gateway ? aws_nat_gateway.main[*].id : []
}

output "production_nat_gateway_ids" {
  description = "IDs of the production VPC NAT gateways"
  value       = var.create_production_vpc && var.enable_nat_gateway ? aws_nat_gateway.production[*].id : []
}

output "development_nat_gateway_ids" {
  description = "IDs of the development VPC NAT gateways"
  value       = var.create_development_vpc && var.enable_nat_gateway ? aws_nat_gateway.development[*].id : []
}

# =============================================================================
# Route Table Outputs
# =============================================================================

output "main_public_route_table_id" {
  description = "ID of the main VPC public route table"
  value       = var.create_main_vpc ? aws_route_table.main_public[0].id : null
}

output "main_private_route_table_ids" {
  description = "IDs of the main VPC private route tables"
  value       = var.create_main_vpc && var.enable_nat_gateway ? aws_route_table.main_private[*].id : []
}

output "production_public_route_table_id" {
  description = "ID of the production VPC public route table"
  value       = var.create_production_vpc ? aws_route_table.production_public[0].id : null
}

output "production_private_route_table_ids" {
  description = "IDs of the production VPC private route tables"
  value       = var.create_production_vpc && var.enable_nat_gateway ? aws_route_table.production_private[*].id : []
}

output "development_public_route_table_id" {
  description = "ID of the development VPC public route table"
  value       = var.create_development_vpc ? aws_route_table.development_public[0].id : null
}

output "development_private_route_table_ids" {
  description = "IDs of the development VPC private route tables"
  value       = var.create_development_vpc && var.enable_nat_gateway ? aws_route_table.development_private[*].id : []
}

# =============================================================================
# Transit Gateway Outputs
# =============================================================================

output "transit_gateway_id" {
  description = "ID of the Transit Gateway"
  value       = var.create_transit_gateway ? aws_ec2_transit_gateway.main[0].id : null
}

output "transit_gateway_arn" {
  description = "ARN of the Transit Gateway"
  value       = var.create_transit_gateway ? aws_ec2_transit_gateway.main[0].arn : null
}

output "transit_gateway_route_table_id" {
  description = "ID of the Transit Gateway route table"
  value       = var.create_transit_gateway ? aws_ec2_transit_gateway_route_table.main[0].id : null
}

output "main_vpc_tgw_attachment_id" {
  description = "ID of the main VPC Transit Gateway attachment"
  value       = var.create_transit_gateway && var.create_main_vpc ? aws_ec2_transit_gateway_vpc_attachment.main[0].id : null
}

output "production_vpc_tgw_attachment_id" {
  description = "ID of the production VPC Transit Gateway attachment"
  value       = var.create_transit_gateway && var.create_production_vpc ? aws_ec2_transit_gateway_vpc_attachment.production[0].id : null
}

output "development_vpc_tgw_attachment_id" {
  description = "ID of the development VPC Transit Gateway attachment"
  value       = var.create_transit_gateway && var.create_development_vpc ? aws_ec2_transit_gateway_vpc_attachment.development[0].id : null
}

# =============================================================================
# VPN Outputs
# =============================================================================

output "customer_gateway_id" {
  description = "ID of the Customer Gateway"
  value       = var.create_vpn ? aws_customer_gateway.main[0].id : null
}

output "vpn_gateway_id" {
  description = "ID of the VPN Gateway"
  value       = var.create_vpn ? aws_vpn_gateway.main[0].id : null
}

output "vpn_connection_id" {
  description = "ID of the VPN Connection"
  value       = var.create_vpn ? aws_vpn_connection.main[0].id : null
}

output "vpn_connection_tunnel1_address" {
  description = "Tunnel 1 address of the VPN Connection"
  value       = var.create_vpn ? aws_vpn_connection.main[0].tunnel1_address : null
}

output "vpn_connection_tunnel2_address" {
  description = "Tunnel 2 address of the VPN Connection"
  value       = var.create_vpn ? aws_vpn_connection.main[0].tunnel2_address : null
}

# =============================================================================
# Load Balancer Outputs
# =============================================================================

output "alb_id" {
  description = "ID of the Application Load Balancer"
  value       = var.create_alb ? aws_lb.application[0].id : null
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = var.create_alb ? aws_lb.application[0].arn : null
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = var.create_alb ? aws_lb.application[0].dns_name : null
}

output "alb_zone_id" {
  description = "Zone ID of the Application Load Balancer"
  value       = var.create_alb ? aws_lb.application[0].zone_id : null
}

output "nlb_id" {
  description = "ID of the Network Load Balancer"
  value       = var.create_nlb ? aws_lb.network[0].id : null
}

output "nlb_arn" {
  description = "ARN of the Network Load Balancer"
  value       = var.create_nlb ? aws_lb.network[0].arn : null
}

output "nlb_dns_name" {
  description = "DNS name of the Network Load Balancer"
  value       = var.create_nlb ? aws_lb.network[0].dns_name : null
}

output "nlb_zone_id" {
  description = "Zone ID of the Network Load Balancer"
  value       = var.create_nlb ? aws_lb.network[0].zone_id : null
}

output "alb_target_group_arn" {
  description = "ARN of the ALB target group"
  value       = var.create_alb ? aws_lb_target_group.application[0].arn : null
}

output "nlb_target_group_arn" {
  description = "ARN of the NLB target group"
  value       = var.create_nlb ? aws_lb_target_group.network[0].arn : null
}

# =============================================================================
# VPC Endpoints Outputs
# =============================================================================

output "s3_vpc_endpoint_id" {
  description = "ID of the S3 VPC endpoint"
  value       = var.create_vpc_endpoints ? aws_vpc_endpoint.s3[0].id : null
}

output "dynamodb_vpc_endpoint_id" {
  description = "ID of the DynamoDB VPC endpoint"
  value       = var.create_vpc_endpoints ? aws_vpc_endpoint.dynamodb[0].id : null
}

output "ec2_vpc_endpoint_id" {
  description = "ID of the EC2 VPC endpoint"
  value       = var.create_vpc_endpoints ? aws_vpc_endpoint.ec2[0].id : null
}

output "ecr_vpc_endpoint_id" {
  description = "ID of the ECR VPC endpoint"
  value       = var.create_vpc_endpoints ? aws_vpc_endpoint.ecr[0].id : null
}

output "ecr_dkr_vpc_endpoint_id" {
  description = "ID of the ECR DKR VPC endpoint"
  value       = var.create_vpc_endpoints ? aws_vpc_endpoint.ecr_dkr[0].id : null
}

# =============================================================================
# Security Group Outputs
# =============================================================================

output "alb_security_group_id" {
  description = "ID of the ALB security group"
  value       = var.create_alb ? aws_security_group.alb[0].id : null
}

output "vpc_endpoints_security_group_id" {
  description = "ID of the VPC endpoints security group"
  value       = var.create_vpc_endpoints ? aws_security_group.vpc_endpoints[0].id : null
}

# =============================================================================
# Summary Outputs
# =============================================================================

output "vpc_summary" {
  description = "Summary of all VPCs created"
  value = {
    main = var.create_main_vpc ? {
      id              = aws_vpc.main[0].id
      cidr_block      = aws_vpc.main[0].cidr_block
      public_subnets  = length(aws_subnet.main_public)
      private_subnets = length(aws_subnet.main_private)
    } : null
    production = var.create_production_vpc ? {
      id              = aws_vpc.production[0].id
      cidr_block      = aws_vpc.production[0].cidr_block
      public_subnets  = length(aws_subnet.production_public)
      private_subnets = length(aws_subnet.production_private)
    } : null
    development = var.create_development_vpc ? {
      id              = aws_vpc.development[0].id
      cidr_block      = aws_vpc.development[0].cidr_block
      public_subnets  = length(aws_subnet.development_public)
      private_subnets = length(aws_subnet.development_private)
    } : null
  }
}

output "load_balancer_summary" {
  description = "Summary of load balancers created"
  value = {
    alb = var.create_alb ? {
      id       = aws_lb.application[0].id
      dns_name = aws_lb.application[0].dns_name
      internal = aws_lb.application[0].internal
    } : null
    nlb = var.create_nlb ? {
      id       = aws_lb.network[0].id
      dns_name = aws_lb.network[0].dns_name
      internal = aws_lb.network[0].internal
    } : null
  }
}

output "connectivity_summary" {
  description = "Summary of connectivity resources created"
  value = {
    transit_gateway = var.create_transit_gateway ? {
      id = aws_ec2_transit_gateway.main[0].id
    } : null
    vpn = var.create_vpn ? {
      customer_gateway_id = aws_customer_gateway.main[0].id
      vpn_gateway_id      = aws_vpn_gateway.main[0].id
      vpn_connection_id   = aws_vpn_connection.main[0].id
    } : null
    vpc_endpoints = var.create_vpc_endpoints ? {
      s3       = aws_vpc_endpoint.s3[0].id
      dynamodb = aws_vpc_endpoint.dynamodb[0].id
      ec2      = aws_vpc_endpoint.ec2[0].id
      ecr      = aws_vpc_endpoint.ecr[0].id
      ecr_dkr  = aws_vpc_endpoint.ecr_dkr[0].id
    } : null
  }
} 