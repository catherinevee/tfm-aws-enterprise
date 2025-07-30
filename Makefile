# =============================================================================
# Enterprise Multi-VPC Infrastructure Makefile
# =============================================================================

.PHONY: help init validate plan apply destroy fmt lint clean test

# Default target
help:
	@echo "Available targets:"
	@echo "  init      - Initialize Terraform"
	@echo "  validate  - Validate Terraform configuration"
	@echo "  plan      - Plan Terraform deployment"
	@echo "  apply     - Apply Terraform configuration"
	@echo "  destroy   - Destroy Terraform resources"
	@echo "  fmt       - Format Terraform code"
	@echo "  lint      - Lint Terraform code"
	@echo "  clean     - Clean up temporary files"
	@echo "  test      - Run validation and plan"

# Initialize Terraform
init:
	@echo "Initializing Terraform..."
	terraform init

# Validate Terraform configuration
validate:
	@echo "Validating Terraform configuration..."
	terraform validate

# Plan Terraform deployment
plan:
	@echo "Planning Terraform deployment..."
	terraform plan

# Apply Terraform configuration
apply:
	@echo "Applying Terraform configuration..."
	terraform apply

# Destroy Terraform resources
destroy:
	@echo "Destroying Terraform resources..."
	terraform destroy

# Format Terraform code
fmt:
	@echo "Formatting Terraform code..."
	terraform fmt -recursive

# Lint Terraform code (requires tflint)
lint:
	@echo "Linting Terraform code..."
	@if command -v tflint >/dev/null 2>&1; then \
		tflint; \
	else \
		echo "tflint not found. Install with: go install github.com/terraform-linters/tflint/cmd/tflint@latest"; \
	fi

# Clean up temporary files
clean:
	@echo "Cleaning up temporary files..."
	rm -rf .terraform
	rm -f .terraform.lock.hcl
	rm -f terraform.tfstate
	rm -f terraform.tfstate.backup
	rm -f *.tfplan

# Run validation and plan
test: validate plan

# Show outputs
outputs:
	@echo "Showing Terraform outputs..."
	terraform output

# Show state
state:
	@echo "Showing Terraform state..."
	terraform show

# Refresh state
refresh:
	@echo "Refreshing Terraform state..."
	terraform refresh

# Import resource (usage: make import ADDRESS=aws_vpc.example ID=vpc-12345)
import:
	@if [ -z "$(ADDRESS)" ] || [ -z "$(ID)" ]; then \
		echo "Usage: make import ADDRESS=aws_vpc.example ID=vpc-12345"; \
		exit 1; \
	fi
	terraform import $(ADDRESS) $(ID)

# Workspace management
workspace-dev:
	@echo "Switching to dev workspace..."
	terraform workspace select dev || terraform workspace new dev

workspace-staging:
	@echo "Switching to staging workspace..."
	terraform workspace select staging || terraform workspace new staging

workspace-prod:
	@echo "Switching to prod workspace..."
	terraform workspace select prod || terraform workspace new prod

# Security scanning (requires terrascan)
security-scan:
	@echo "Running security scan..."
	@if command -v terrascan >/dev/null 2>&1; then \
		terrascan scan -i terraform; \
	else \
		echo "terrascan not found. Install with: go install github.com/tenable/terrascan/cmd/terrascan@latest"; \
	fi

# Cost estimation (requires infracost)
cost-estimate:
	@echo "Estimating costs..."
	@if command -v infracost >/dev/null 2>&1; then \
		infracost breakdown --path .; \
	else \
		echo "infracost not found. Install with: curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | sh"; \
	fi

# Documentation generation
docs:
	@echo "Generating documentation..."
	@if command -v terraform-docs >/dev/null 2>&1; then \
		terraform-docs markdown table . > README.md; \
	else \
		echo "terraform-docs not found. Install with: go install github.com/terraform-docs/terraform-docs@latest"; \
	fi

# Pre-commit hooks
pre-commit: fmt validate lint security-scan

# CI/CD pipeline
ci: init validate fmt lint security-scan plan 