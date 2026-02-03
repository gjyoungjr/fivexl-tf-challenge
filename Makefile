
# ============================================
# CONFIGURATION - Update these values
# ============================================
AWS_PROFILE ?= devan
AWS_REGION  ?= us-east-1

# Default environment (can override: make plan ENV=prod)
ENV ?= dev

# Hosting type: s3 or ec2 (optional override, defaults to tfvars value)
HOSTING ?=

# ============================================
# VARIABLES
# ============================================
TF_VARS_FILE = environments/$(ENV).tfvars
TERRAFORM = AWS_PROFILE=$(AWS_PROFILE) AWS_REGION=$(AWS_REGION) terraform

# Build extra vars if HOSTING is specified
ifdef HOSTING
  TF_EXTRA_VARS = -var="hosting_type=$(HOSTING)"
else
  TF_EXTRA_VARS =
endif

# ============================================
# TARGETS
# ============================================

.PHONY: help init plan apply destroy fmt validate clean whoami

help: ## Show this help message
	@echo "Usage: make [target] [ENV=dev|prod] [HOSTING=s3|ec2]"
	@echo ""
	@echo "Configuration:"
	@echo "  AWS_PROFILE = $(AWS_PROFILE)"
	@echo "  ENV         = $(ENV)"
	@echo "  HOSTING     = $(if $(HOSTING),$(HOSTING),(from tfvars))"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s %s\n", $$1, $$2}'

whoami: ## Show current AWS identity
	@AWS_PROFILE=$(AWS_PROFILE) aws sts get-caller-identity

tf-init: ## Initialize Terraform
	$(TERRAFORM) init

tf-plan: ## Run Terraform plan (HOSTING=s3|ec2)
	$(TERRAFORM) plan -var-file=$(TF_VARS_FILE) $(TF_EXTRA_VARS)

tf-apply: ## Run Terraform apply (HOSTING=s3|ec2)
	$(TERRAFORM) apply -var-file=$(TF_VARS_FILE) $(TF_EXTRA_VARS)

tf-destroy: ## Run Terraform destroy (HOSTING=s3|ec2)
	$(TERRAFORM) destroy -var-file=$(TF_VARS_FILE) $(TF_EXTRA_VARS)

tf-fmt: ## Format Terraform files
	$(TERRAFORM) fmt -recursive

tf-validate: init ## Validate Terraform configuration
	$(TERRAFORM) validate

clean: ## Remove Terraform cache files
	rm -rf .terraform
	rm -f .terraform.lock.hcl
	rm -f terraform.tfstate*
