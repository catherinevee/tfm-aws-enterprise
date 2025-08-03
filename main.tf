# =============================================================================
# Enterprise Multi-VPC Infrastructure Module
# =============================================================================

# =============================================================================
# Data Sources
# =============================================================================

data "aws_availability_zones" "available" {
  state = "available"  # Default: available - Only show available AZs
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

# =============================================================================
# VPC Resources
# =============================================================================

# Main VPC
resource "aws_vpc" "main" {
  count = var.create_main_vpc ? 1 : 0

  cidr_block           = var.main_vpc_cidr  # Default: 10.0.0.0/16 - Main VPC CIDR block
  enable_dns_hostnames = var.main_vpc_enable_dns_hostnames  # Default: true - Enable DNS hostnames for instances
  enable_dns_support   = var.main_vpc_enable_dns_support    # Default: true - Enable DNS support for the VPC
  assign_generated_ipv6_cidr_block = var.main_vpc_assign_generated_ipv6_cidr_block  # Default: false - Assign IPv6 CIDR block
  ipv6_cidr_block      = var.main_vpc_ipv6_cidr_block      # Default: null - Custom IPv6 CIDR block
  ipv6_cidr_block_network_border_group = var.main_vpc_ipv6_cidr_block_network_border_group  # Default: null - Network border group for IPv6

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-main-vpc"
      Type = "Main"
    }
  )
}

# Production VPC
resource "aws_vpc" "production" {
  count = var.create_production_vpc ? 1 : 0

  cidr_block           = var.production_vpc_cidr  # Default: 10.1.0.0/16 - Production VPC CIDR block
  enable_dns_hostnames = var.production_vpc_enable_dns_hostnames  # Default: true - Enable DNS hostnames for instances
  enable_dns_support   = var.production_vpc_enable_dns_support    # Default: true - Enable DNS support for the VPC
  assign_generated_ipv6_cidr_block = var.production_vpc_assign_generated_ipv6_cidr_block  # Default: false - Assign IPv6 CIDR block
  ipv6_cidr_block      = var.production_vpc_ipv6_cidr_block      # Default: null - Custom IPv6 CIDR block
  ipv6_cidr_block_network_border_group = var.production_vpc_ipv6_cidr_block_network_border_group  # Default: null - Network border group for IPv6

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-production-vpc"
      Type = "Production"
    }
  )
}

# Development VPC
resource "aws_vpc" "development" {
  count = var.create_development_vpc ? 1 : 0

  cidr_block           = var.development_vpc_cidr  # Default: 10.2.0.0/16 - Development VPC CIDR block
  enable_dns_hostnames = var.development_vpc_enable_dns_hostnames  # Default: true - Enable DNS hostnames for instances
  enable_dns_support   = var.development_vpc_enable_dns_support    # Default: true - Enable DNS support for the VPC
  assign_generated_ipv6_cidr_block = var.development_vpc_assign_generated_ipv6_cidr_block  # Default: false - Assign IPv6 CIDR block
  ipv6_cidr_block      = var.development_vpc_ipv6_cidr_block      # Default: null - Custom IPv6 CIDR block
  ipv6_cidr_block_network_border_group = var.development_vpc_ipv6_cidr_block_network_border_group  # Default: null - Network border group for IPv6

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-development-vpc"
      Type = "Development"
    }
  )
}

# =============================================================================
# Internet Gateways
# =============================================================================

resource "aws_internet_gateway" "main" {
  count = var.create_main_vpc ? 1 : 0

  vpc_id = aws_vpc.main[0].id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-main-igw"
    }
  )
}

resource "aws_internet_gateway" "production" {
  count = var.create_production_vpc ? 1 : 0

  vpc_id = aws_vpc.production[0].id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-production-igw"
    }
  )
}

resource "aws_internet_gateway" "development" {
  count = var.create_development_vpc ? 1 : 0

  vpc_id = aws_vpc.development[0].id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-development-igw"
    }
  )
}

# =============================================================================
# Subnets
# =============================================================================

# Main VPC Subnets
resource "aws_subnet" "main_public" {
  count = var.create_main_vpc ? length(var.main_public_subnets) : 0

  vpc_id                  = aws_vpc.main[0].id
  cidr_block              = var.main_public_subnets[count.index]  # Default: ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"] - Public subnet CIDRs
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = var.main_public_subnet_map_public_ip_on_launch  # Default: true - Auto-assign public IPs
  assign_ipv6_address_on_creation = var.main_public_subnet_assign_ipv6_address_on_creation  # Default: false - Auto-assign IPv6 addresses
  ipv6_cidr_block = var.main_public_subnet_ipv6_cidr_blocks != null ? var.main_public_subnet_ipv6_cidr_blocks[count.index] : null  # Default: null - IPv6 CIDR block

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-main-public-${data.aws_availability_zones.available.names[count.index]}"
      Type = "Public"
    }
  )
}

resource "aws_subnet" "main_private" {
  count = var.create_main_vpc ? length(var.main_private_subnets) : 0

  vpc_id            = aws_vpc.main[0].id
  cidr_block        = var.main_private_subnets[count.index]  # Default: ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"] - Private subnet CIDRs
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = var.main_private_subnet_map_public_ip_on_launch  # Default: false - Don't auto-assign public IPs
  assign_ipv6_address_on_creation = var.main_private_subnet_assign_ipv6_address_on_creation  # Default: false - Auto-assign IPv6 addresses
  ipv6_cidr_block = var.main_private_subnet_ipv6_cidr_blocks != null ? var.main_private_subnet_ipv6_cidr_blocks[count.index] : null  # Default: null - IPv6 CIDR block

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-main-private-${data.aws_availability_zones.available.names[count.index]}"
      Type = "Private"
    }
  )
}

# Production VPC Subnets
resource "aws_subnet" "production_public" {
  count = var.create_production_vpc ? length(var.production_public_subnets) : 0

  vpc_id                  = aws_vpc.production[0].id
  cidr_block              = var.production_public_subnets[count.index]  # Default: ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"] - Public subnet CIDRs
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = var.production_public_subnet_map_public_ip_on_launch  # Default: true - Auto-assign public IPs
  assign_ipv6_address_on_creation = var.production_public_subnet_assign_ipv6_address_on_creation  # Default: false - Auto-assign IPv6 addresses
  ipv6_cidr_block = var.production_public_subnet_ipv6_cidr_blocks != null ? var.production_public_subnet_ipv6_cidr_blocks[count.index] : null  # Default: null - IPv6 CIDR block

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-production-public-${data.aws_availability_zones.available.names[count.index]}"
      Type = "Public"
    }
  )
}

resource "aws_subnet" "production_private" {
  count = var.create_production_vpc ? length(var.production_private_subnets) : 0

  vpc_id            = aws_vpc.production[0].id
  cidr_block        = var.production_private_subnets[count.index]  # Default: ["10.1.10.0/24", "10.1.11.0/24", "10.1.12.0/24"] - Private subnet CIDRs
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = var.production_private_subnet_map_public_ip_on_launch  # Default: false - Don't auto-assign public IPs
  assign_ipv6_address_on_creation = var.production_private_subnet_assign_ipv6_address_on_creation  # Default: false - Auto-assign IPv6 addresses
  ipv6_cidr_block = var.production_private_subnet_ipv6_cidr_blocks != null ? var.production_private_subnet_ipv6_cidr_blocks[count.index] : null  # Default: null - IPv6 CIDR block

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-production-private-${data.aws_availability_zones.available.names[count.index]}"
      Type = "Private"
    }
  )
}

# Development VPC Subnets
resource "aws_subnet" "development_public" {
  count = var.create_development_vpc ? length(var.development_public_subnets) : 0

  vpc_id                  = aws_vpc.development[0].id
  cidr_block              = var.development_public_subnets[count.index]  # Default: ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"] - Public subnet CIDRs
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = var.development_public_subnet_map_public_ip_on_launch  # Default: true - Auto-assign public IPs
  assign_ipv6_address_on_creation = var.development_public_subnet_assign_ipv6_address_on_creation  # Default: false - Auto-assign IPv6 addresses
  ipv6_cidr_block = var.development_public_subnet_ipv6_cidr_blocks != null ? var.development_public_subnet_ipv6_cidr_blocks[count.index] : null  # Default: null - IPv6 CIDR block

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-development-public-${data.aws_availability_zones.available.names[count.index]}"
      Type = "Public"
    }
  )
}

resource "aws_subnet" "development_private" {
  count = var.create_development_vpc ? length(var.development_private_subnets) : 0

  vpc_id            = aws_vpc.development[0].id
  cidr_block        = var.development_private_subnets[count.index]  # Default: ["10.2.10.0/24", "10.2.11.0/24", "10.2.12.0/24"] - Private subnet CIDRs
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = var.development_private_subnet_map_public_ip_on_launch  # Default: false - Don't auto-assign public IPs
  assign_ipv6_address_on_creation = var.development_private_subnet_assign_ipv6_address_on_creation  # Default: false - Auto-assign IPv6 addresses
  ipv6_cidr_block = var.development_private_subnet_ipv6_cidr_blocks != null ? var.development_private_subnet_ipv6_cidr_blocks[count.index] : null  # Default: null - IPv6 CIDR block

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-development-private-${data.aws_availability_zones.available.names[count.index]}"
      Type = "Private"
    }
  )
}

# =============================================================================
# NAT Gateways
# =============================================================================

# Elastic IPs for NAT Gateways
resource "aws_eip" "main_nat" {
  count = var.create_main_vpc && var.enable_nat_gateway ? length(var.main_public_subnets) : 0

  domain = "vpc"  # Default: vpc - EIP domain type

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-main-nat-eip-${count.index + 1}"
    }
  )
}

resource "aws_eip" "production_nat" {
  count = var.create_production_vpc && var.enable_nat_gateway ? length(var.production_public_subnets) : 0

  domain = "vpc"  # Default: vpc - EIP domain type

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-production-nat-eip-${count.index + 1}"
    }
  )
}

resource "aws_eip" "development_nat" {
  count = var.create_development_vpc && var.enable_nat_gateway ? length(var.development_public_subnets) : 0

  domain = "vpc"  # Default: vpc - EIP domain type

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-development-nat-eip-${count.index + 1}"
    }
  )
}

# NAT Gateways
resource "aws_nat_gateway" "main" {
  count = var.create_main_vpc && var.enable_nat_gateway ? length(var.main_public_subnets) : 0

  allocation_id = aws_eip.main_nat[count.index].id
  subnet_id     = aws_subnet.main_public[count.index].id  # Default: Public subnet - NAT Gateway placement

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-main-nat-${count.index + 1}"
    }
  )

  depends_on = [aws_internet_gateway.main]
}

resource "aws_nat_gateway" "production" {
  count = var.create_production_vpc && var.enable_nat_gateway ? length(var.production_public_subnets) : 0

  allocation_id = aws_eip.production_nat[count.index].id
  subnet_id     = aws_subnet.production_public[count.index].id  # Default: Public subnet - NAT Gateway placement

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-production-nat-${count.index + 1}"
    }
  )

  depends_on = [aws_internet_gateway.production]
}

resource "aws_nat_gateway" "development" {
  count = var.create_development_vpc && var.enable_nat_gateway ? length(var.development_public_subnets) : 0

  allocation_id = aws_eip.development_nat[count.index].id
  subnet_id     = aws_subnet.development_public[count.index].id  # Default: Public subnet - NAT Gateway placement

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-development-nat-${count.index + 1}"
    }
  )

  depends_on = [aws_internet_gateway.development]
}

# =============================================================================
# Route Tables
# =============================================================================

# Main VPC Route Tables
resource "aws_route_table" "main_public" {
  count = var.create_main_vpc ? 1 : 0

  vpc_id = aws_vpc.main[0].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main[0].id
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-main-public-rt"
    }
  )
}

resource "aws_route_table" "main_private" {
  count = var.create_main_vpc && var.enable_nat_gateway ? length(var.main_private_subnets) : 0

  vpc_id = aws_vpc.main[0].id

  dynamic "route" {
    for_each = var.enable_nat_gateway ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.main[count.index].id
    }
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-main-private-rt-${count.index + 1}"
    }
  )
}

# Production VPC Route Tables
resource "aws_route_table" "production_public" {
  count = var.create_production_vpc ? 1 : 0

  vpc_id = aws_vpc.production[0].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.production[0].id
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-production-public-rt"
    }
  )
}

resource "aws_route_table" "production_private" {
  count = var.create_production_vpc && var.enable_nat_gateway ? length(var.production_private_subnets) : 0

  vpc_id = aws_vpc.production[0].id

  dynamic "route" {
    for_each = var.enable_nat_gateway ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.production[count.index].id
    }
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-production-private-rt-${count.index + 1}"
    }
  )
}

# Development VPC Route Tables
resource "aws_route_table" "development_public" {
  count = var.create_development_vpc ? 1 : 0

  vpc_id = aws_vpc.development[0].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.development[0].id
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-development-public-rt"
    }
  )
}

resource "aws_route_table" "development_private" {
  count = var.create_development_vpc && var.enable_nat_gateway ? length(var.development_private_subnets) : 0

  vpc_id = aws_vpc.development[0].id

  dynamic "route" {
    for_each = var.enable_nat_gateway ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.development[count.index].id
    }
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-development-private-rt-${count.index + 1}"
    }
  )
}

# =============================================================================
# Route Table Associations
# =============================================================================

# Main VPC Route Table Associations
resource "aws_route_table_association" "main_public" {
  count = var.create_main_vpc ? length(var.main_public_subnets) : 0

  subnet_id      = aws_subnet.main_public[count.index].id
  route_table_id = aws_route_table.main_public[0].id
}

resource "aws_route_table_association" "main_private" {
  count = var.create_main_vpc ? length(var.main_private_subnets) : 0

  subnet_id      = aws_subnet.main_private[count.index].id
  route_table_id = aws_route_table.main_private[count.index].id
}

# Production VPC Route Table Associations
resource "aws_route_table_association" "production_public" {
  count = var.create_production_vpc ? length(var.production_public_subnets) : 0

  subnet_id      = aws_subnet.production_public[count.index].id
  route_table_id = aws_route_table.production_public[0].id
}

resource "aws_route_table_association" "production_private" {
  count = var.create_production_vpc ? length(var.production_private_subnets) : 0

  subnet_id      = aws_subnet.production_private[count.index].id
  route_table_id = aws_route_table.production_private[count.index].id
}

# Development VPC Route Table Associations
resource "aws_route_table_association" "development_public" {
  count = var.create_development_vpc ? length(var.development_public_subnets) : 0

  subnet_id      = aws_subnet.development_public[count.index].id
  route_table_id = aws_route_table.development_public[0].id
}

resource "aws_route_table_association" "development_private" {
  count = var.create_development_vpc ? length(var.development_private_subnets) : 0

  subnet_id      = aws_subnet.development_private[count.index].id
  route_table_id = aws_route_table.development_private[count.index].id
}

# =============================================================================
# Transit Gateway
# =============================================================================

resource "aws_ec2_transit_gateway" "main" {
  count = var.create_transit_gateway ? 1 : 0

  description                     = "Transit Gateway for ${var.environment}"
  default_route_table_association = var.transit_gateway_default_route_table_association  # Default: enable - Enable default route table association
  default_route_table_propagation = var.transit_gateway_default_route_table_propagation  # Default: enable - Enable default route table propagation
  auto_accept_shared_attachments  = var.transit_gateway_auto_accept_shared_attachments  # Default: enable - Auto-accept shared attachments
  amazon_side_asn                 = var.transit_gateway_asn  # Default: 64512 - Amazon side ASN
  dns_support                     = var.transit_gateway_dns_support  # Default: enable - Enable DNS support
  vpn_ecmp_support                = var.transit_gateway_vpn_ecmp_support  # Default: enable - Enable VPN ECMP support
  multicast_support               = var.transit_gateway_multicast_support  # Default: disable - Enable multicast support

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-transit-gateway"
    }
  )
}

# Transit Gateway Route Table
resource "aws_ec2_transit_gateway_route_table" "main" {
  count = var.create_transit_gateway ? 1 : 0

  transit_gateway_id = aws_ec2_transit_gateway.main[0].id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-tgw-route-table"
    }
  )
}

# Transit Gateway VPC Attachments
resource "aws_ec2_transit_gateway_vpc_attachment" "main" {
  count = var.create_transit_gateway && var.create_main_vpc ? 1 : 0

  subnet_ids         = aws_subnet.main_private[*].id  # Default: Private subnets - TGW attachment placement
  transit_gateway_id = aws_ec2_transit_gateway.main[0].id
  vpc_id             = aws_vpc.main[0].id
  appliance_mode_support = var.transit_gateway_appliance_mode_support  # Default: disable - Enable appliance mode support
  dns_support = var.transit_gateway_attachment_dns_support  # Default: enable - Enable DNS support for attachments
  ipv6_support = var.transit_gateway_attachment_ipv6_support  # Default: disable - Enable IPv6 support for attachments

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-main-vpc-tgw-attachment"
    }
  )
}

resource "aws_ec2_transit_gateway_vpc_attachment" "production" {
  count = var.create_transit_gateway && var.create_production_vpc ? 1 : 0

  subnet_ids         = aws_subnet.production_private[*].id  # Default: Private subnets - TGW attachment placement
  transit_gateway_id = aws_ec2_transit_gateway.main[0].id
  vpc_id             = aws_vpc.production[0].id
  appliance_mode_support = var.transit_gateway_appliance_mode_support  # Default: disable - Enable appliance mode support
  dns_support = var.transit_gateway_attachment_dns_support  # Default: enable - Enable DNS support for attachments
  ipv6_support = var.transit_gateway_attachment_ipv6_support  # Default: disable - Enable IPv6 support for attachments

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-production-vpc-tgw-attachment"
    }
  )
}

resource "aws_ec2_transit_gateway_vpc_attachment" "development" {
  count = var.create_transit_gateway && var.create_development_vpc ? 1 : 0

  subnet_ids         = aws_subnet.development_private[*].id  # Default: Private subnets - TGW attachment placement
  transit_gateway_id = aws_ec2_transit_gateway.main[0].id
  vpc_id             = aws_vpc.development[0].id
  appliance_mode_support = var.transit_gateway_appliance_mode_support  # Default: disable - Enable appliance mode support
  dns_support = var.transit_gateway_attachment_dns_support  # Default: enable - Enable DNS support for attachments
  ipv6_support = var.transit_gateway_attachment_ipv6_support  # Default: disable - Enable IPv6 support for attachments

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-development-vpc-tgw-attachment"
    }
  )
}

# =============================================================================
# Site-to-Site VPN
# =============================================================================

# Customer Gateway
resource "aws_customer_gateway" "main" {
  count = var.create_vpn ? 1 : 0

  bgp_asn    = var.customer_gateway_bgp_asn
  ip_address = var.customer_gateway_ip
  type       = "ipsec.1"

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-customer-gateway"
    }
  )
}

# VPN Gateway
resource "aws_vpn_gateway" "main" {
  count = var.create_vpn ? 1 : 0

  vpc_id = aws_vpc.main[0].id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-vpn-gateway"
    }
  )
}

# VPN Connection
resource "aws_vpn_connection" "main" {
  count = var.create_vpn ? 1 : 0

  vpn_gateway_id      = aws_vpn_gateway.main[0].id
  customer_gateway_id = aws_customer_gateway.main[0].id
  type                = "ipsec.1"
  static_routes_only  = var.vpn_static_routes_only

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-vpn-connection"
    }
  )
}

# =============================================================================
# Load Balancers
# =============================================================================

# Application Load Balancer
resource "aws_lb" "application" {
  count = var.create_alb ? 1 : 0

  name               = "${var.environment}-alb"
  internal           = var.alb_internal
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb[0].id]
  subnets            = var.alb_internal ? aws_subnet.main_private[*].id : aws_subnet.main_public[*].id

  enable_deletion_protection = var.alb_deletion_protection

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-application-load-balancer"
    }
  )
}

# Network Load Balancer
resource "aws_lb" "network" {
  count = var.create_nlb ? 1 : 0

  name               = "${var.environment}-nlb"
  internal           = var.nlb_internal
  load_balancer_type = "network"
  subnets            = var.nlb_internal ? aws_subnet.main_private[*].id : aws_subnet.main_public[*].id

  enable_deletion_protection = var.nlb_deletion_protection

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-network-load-balancer"
    }
  )
}

# ALB Target Group
resource "aws_lb_target_group" "application" {
  count = var.create_alb ? 1 : 0

  name     = "${var.environment}-alb-tg"
  port     = var.alb_target_port
  protocol = "HTTP"
  vpc_id   = aws_vpc.main[0].id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = var.alb_health_check_path
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-alb-target-group"
    }
  )
}

# NLB Target Group
resource "aws_lb_target_group" "network" {
  count = var.create_nlb ? 1 : 0

  name     = "${var.environment}-nlb-tg"
  port     = var.nlb_target_port
  protocol = "TCP"
  vpc_id   = aws_vpc.main[0].id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    port                = "traffic-port"
    protocol            = "TCP"
    timeout             = 10
    unhealthy_threshold = 2
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-nlb-target-group"
    }
  )
}

# ALB Listener
resource "aws_lb_listener" "application" {
  count = var.create_alb ? 1 : 0

  load_balancer_arn = aws_lb.application[0].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.application[0].arn
  }
}

# NLB Listener
resource "aws_lb_listener" "network" {
  count = var.create_nlb ? 1 : 0

  load_balancer_arn = aws_lb.network[0].arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.network[0].arn
  }
}

# =============================================================================
# VPC Endpoints
# =============================================================================

# S3 VPC Endpoint
resource "aws_vpc_endpoint" "s3" {
  count = var.create_vpc_endpoints ? 1 : 0

  vpc_id       = aws_vpc.main[0].id
  service_name = "com.amazonaws.${data.aws_region.current.name}.s3"

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-s3-vpc-endpoint"
    }
  )
}

# DynamoDB VPC Endpoint
resource "aws_vpc_endpoint" "dynamodb" {
  count = var.create_vpc_endpoints ? 1 : 0

  vpc_id       = aws_vpc.main[0].id
  service_name = "com.amazonaws.${data.aws_region.current.name}.dynamodb"

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-dynamodb-vpc-endpoint"
    }
  )
}

# EC2 VPC Endpoint
resource "aws_vpc_endpoint" "ec2" {
  count = var.create_vpc_endpoints ? 1 : 0

  vpc_id             = aws_vpc.main[0].id
  service_name       = "com.amazonaws.${data.aws_region.current.name}.ec2"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = aws_subnet.main_private[*].id
  security_group_ids = [aws_security_group.vpc_endpoints[0].id]

  private_dns_enabled = true

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-ec2-vpc-endpoint"
    }
  )
}

# ECR VPC Endpoint
resource "aws_vpc_endpoint" "ecr" {
  count = var.create_vpc_endpoints ? 1 : 0

  vpc_id             = aws_vpc.main[0].id
  service_name       = "com.amazonaws.${data.aws_region.current.name}.ecr.api"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = aws_subnet.main_private[*].id
  security_group_ids = [aws_security_group.vpc_endpoints[0].id]

  private_dns_enabled = true

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-ecr-api-vpc-endpoint"
    }
  )
}

# ECR DKR VPC Endpoint
resource "aws_vpc_endpoint" "ecr_dkr" {
  count = var.create_vpc_endpoints ? 1 : 0

  vpc_id             = aws_vpc.main[0].id
  service_name       = "com.amazonaws.${data.aws_region.current.name}.ecr.dkr"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = aws_subnet.main_private[*].id
  security_group_ids = [aws_security_group.vpc_endpoints[0].id]

  private_dns_enabled = true

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-ecr-dkr-vpc-endpoint"
    }
  )
}

# =============================================================================
# Security Groups
# =============================================================================

# ALB Security Group
resource "aws_security_group" "alb" {
  count = var.create_alb ? 1 : 0

  name        = "${var.environment}-alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = aws_vpc.main[0].id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-alb-security-group"
    }
  )
}

# VPC Endpoints Security Group
resource "aws_security_group" "vpc_endpoints" {
  count = var.create_vpc_endpoints ? 1 : 0

  name        = "${var.environment}-vpc-endpoints-sg"
  description = "Security group for VPC Endpoints"
  vpc_id      = aws_vpc.main[0].id

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.main_vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-vpc-endpoints-security-group"
    }
  )
}

# =============================================================================
# VPC Endpoint Route Table Associations
# =============================================================================

# S3 VPC Endpoint Route Table Association
resource "aws_vpc_endpoint_route_table_association" "s3" {
  count = var.create_vpc_endpoints ? length(aws_subnet.main_private) : 0

  route_table_id  = aws_route_table.main_private[count.index].id
  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
}

# DynamoDB VPC Endpoint Route Table Association
resource "aws_vpc_endpoint_route_table_association" "dynamodb" {
  count = var.create_vpc_endpoints ? length(aws_subnet.main_private) : 0

  route_table_id  = aws_route_table.main_private[count.index].id
  vpc_endpoint_id = aws_vpc_endpoint.dynamodb[0].id
} 