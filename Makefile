
# ============================================
# CONFIGURATION - Update these values
# ============================================
AWS_PROFILE ?= devan
AWS_REGION  ?= us-east-1

# Default environment (can override: make plan ENV=prod)
ENV ?= dev

# ============================================
# VARIABLES
# ============================================
TF_VARS_FILE = environments/$(ENV).tfvars
TERRAFORM = AWS_PROFILE=$(AWS_PROFILE) AWS_REGION=$(AWS_REGION) terraform

# ============================================
# TARGETS
# ============================================

.PHONY: help init plan apply destroy fmt validate clean whoami

help: ## Show this help message
	@echo "Usage: make [target] [ENV=dev|prod]"
	@echo ""
	@echo "Configuration:"
	@echo "  AWS_PROFILE = $(AWS_PROFILE)"
	@echo "  ENV         = $(ENV)"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s %s\n", $$1, $$2}'

whoami: ## Show current AWS identity
	@AWS_PROFILE=$(AWS_PROFILE) aws sts get-caller-identity

tf-init: ## Initialize Terraform
	$(TERRAFORM) init -migrate-state

tf-plan: ## Run Terraform plan
	$(TERRAFORM) plan -var-file=$(TF_VARS_FILE)

tf-apply: ## Run Terraform apply
	$(TERRAFORM) apply -var-file=$(TF_VARS_FILE)

tf-destroy: ## Run Terraform destroy
	$(TERRAFORM) destroy -var-file=$(TF_VARS_FILE)

tf-fmt: ## Format Terraform files
	$(TERRAFORM) fmt -recursive

tf-validate: init ## Validate Terraform configuration
	$(TERRAFORM) validate

clean: ## Remove Terraform cache files
	rm -rf .terraform
	rm -f .terraform.lock.hcl
	rm -f terraform.tfstate*
