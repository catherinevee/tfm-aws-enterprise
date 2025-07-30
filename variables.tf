# =============================================================================
# Enterprise Multi-VPC Infrastructure Variables
# =============================================================================

# =============================================================================
# General Variables
# =============================================================================

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod", "test"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod, test."
  }
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Terraform   = "true"
    Environment = "dev"
    Project     = "enterprise-infrastructure"
  }
}

# =============================================================================
# VPC Configuration Variables
# =============================================================================

variable "create_main_vpc" {
  description = "Whether to create the main VPC"
  type        = bool
  default     = true
}

variable "create_production_vpc" {
  description = "Whether to create the production VPC"
  type        = bool
  default     = false
}

variable "create_development_vpc" {
  description = "Whether to create the development VPC"
  type        = bool
  default     = false
}

variable "main_vpc_cidr" {
  description = "CIDR block for the main VPC"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.main_vpc_cidr, 0))
    error_message = "Main VPC CIDR block must be a valid CIDR notation."
  }
}

variable "production_vpc_cidr" {
  description = "CIDR block for the production VPC"
  type        = string
  default     = "10.1.0.0/16"

  validation {
    condition     = can(cidrhost(var.production_vpc_cidr, 0))
    error_message = "Production VPC CIDR block must be a valid CIDR notation."
  }
}

variable "development_vpc_cidr" {
  description = "CIDR block for the development VPC"
  type        = string
  default     = "10.2.0.0/16"

  validation {
    condition     = can(cidrhost(var.development_vpc_cidr, 0))
    error_message = "Development VPC CIDR block must be a valid CIDR notation."
  }
}

# =============================================================================
# Subnet Configuration Variables
# =============================================================================

variable "main_public_subnets" {
  description = "List of public subnet CIDR blocks for main VPC"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

  validation {
    condition = alltrue([
      for subnet in var.main_public_subnets : can(cidrhost(subnet, 0))
    ])
    error_message = "All main public subnet CIDR blocks must be valid CIDR notation."
  }
}

variable "main_private_subnets" {
  description = "List of private subnet CIDR blocks for main VPC"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]

  validation {
    condition = alltrue([
      for subnet in var.main_private_subnets : can(cidrhost(subnet, 0))
    ])
    error_message = "All main private subnet CIDR blocks must be valid CIDR notation."
  }
}

variable "production_public_subnets" {
  description = "List of public subnet CIDR blocks for production VPC"
  type        = list(string)
  default     = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]

  validation {
    condition = alltrue([
      for subnet in var.production_public_subnets : can(cidrhost(subnet, 0))
    ])
    error_message = "All production public subnet CIDR blocks must be valid CIDR notation."
  }
}

variable "production_private_subnets" {
  description = "List of private subnet CIDR blocks for production VPC"
  type        = list(string)
  default     = ["10.1.11.0/24", "10.1.12.0/24", "10.1.13.0/24"]

  validation {
    condition = alltrue([
      for subnet in var.production_private_subnets : can(cidrhost(subnet, 0))
    ])
    error_message = "All production private subnet CIDR blocks must be valid CIDR notation."
  }
}

variable "development_public_subnets" {
  description = "List of public subnet CIDR blocks for development VPC"
  type        = list(string)
  default     = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]

  validation {
    condition = alltrue([
      for subnet in var.development_public_subnets : can(cidrhost(subnet, 0))
    ])
    error_message = "All development public subnet CIDR blocks must be valid CIDR notation."
  }
}

variable "development_private_subnets" {
  description = "List of private subnet CIDR blocks for development VPC"
  type        = list(string)
  default     = ["10.2.11.0/24", "10.2.12.0/24", "10.2.13.0/24"]

  validation {
    condition = alltrue([
      for subnet in var.development_private_subnets : can(cidrhost(subnet, 0))
    ])
    error_message = "All development private subnet CIDR blocks must be valid CIDR notation."
  }
}

# =============================================================================
# NAT Gateway Variables
# =============================================================================

variable "enable_nat_gateway" {
  description = "Whether to enable NAT Gateway for private subnets"
  type        = bool
  default     = true
}

# =============================================================================
# Transit Gateway Variables
# =============================================================================

variable "create_transit_gateway" {
  description = "Whether to create Transit Gateway for VPC connectivity"
  type        = bool
  default     = true
}

# =============================================================================
# VPN Variables
# =============================================================================

variable "create_vpn" {
  description = "Whether to create Site-to-Site VPN connection"
  type        = bool
  default     = false
}

variable "customer_gateway_bgp_asn" {
  description = "BGP ASN for the customer gateway"
  type        = number
  default     = 65000

  validation {
    condition     = var.customer_gateway_bgp_asn >= 1 && var.customer_gateway_bgp_asn <= 65534
    error_message = "BGP ASN must be between 1 and 65534."
  }
}

variable "customer_gateway_ip" {
  description = "IP address of the customer gateway"
  type        = string
  default     = ""

  validation {
    condition     = var.customer_gateway_ip == "" || can(cidrhost("${var.customer_gateway_ip}/32", 0))
    error_message = "Customer gateway IP must be a valid IP address."
  }
}

variable "vpn_static_routes_only" {
  description = "Whether to use static routes only for VPN"
  type        = bool
  default     = true
}

# =============================================================================
# Load Balancer Variables
# =============================================================================

variable "create_alb" {
  description = "Whether to create Application Load Balancer"
  type        = bool
  default     = false
}

variable "create_nlb" {
  description = "Whether to create Network Load Balancer"
  type        = bool
  default     = false
}

variable "alb_internal" {
  description = "Whether the ALB is internal (private)"
  type        = bool
  default     = false
}

variable "nlb_internal" {
  description = "Whether the NLB is internal (private)"
  type        = bool
  default     = false
}

variable "alb_deletion_protection" {
  description = "Whether to enable deletion protection for ALB"
  type        = bool
  default     = false
}

variable "nlb_deletion_protection" {
  description = "Whether to enable deletion protection for NLB"
  type        = bool
  default     = false
}

variable "alb_target_port" {
  description = "Target port for ALB target group"
  type        = number
  default     = 80

  validation {
    condition     = var.alb_target_port >= 1 && var.alb_target_port <= 65535
    error_message = "ALB target port must be between 1 and 65535."
  }
}

variable "nlb_target_port" {
  description = "Target port for NLB target group"
  type        = number
  default     = 80

  validation {
    condition     = var.nlb_target_port >= 1 && var.nlb_target_port <= 65535
    error_message = "NLB target port must be between 1 and 65535."
  }
}

variable "alb_health_check_path" {
  description = "Health check path for ALB target group"
  type        = string
  default     = "/"
}

# =============================================================================
# VPC Endpoints Variables
# =============================================================================

variable "create_vpc_endpoints" {
  description = "Whether to create VPC endpoints for AWS services"
  type        = bool
  default     = false
} 