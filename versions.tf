# =============================================================================
# Terraform and Provider Versions
# =============================================================================

terraform {
  required_version = ">= 1.13.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.2.0"
    }
  }
}

# =============================================================================
# Provider Configuration
# =============================================================================

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Terraform   = "true"
      Environment = "dev"
      Project     = "enterprise-infrastructure"
    }
  }
} 