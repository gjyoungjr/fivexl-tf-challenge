# FiveXL Terraform Challenge

Terraform project for deploying a static website to AWS S3.

## Prerequisites

- Terraform >= 1.0
- AWS CLI configured with appropriate credentials
- Make

## Quick Start

```bash
# Initialize Terraform
make tf-init

# Preview changes
make tf-plan

# Deploy
make tf-apply
```

## Environments

Switch between environments using the `ENV` variable:

```bash
make tf-plan ENV=dev   # default
make tf-plan ENV=prod
```

Environment configs are in `environments/`.

## Make Targets

| Target       | Description                   |
|--------------|-------------------------------|
| `tf-init`    | Initialize Terraform          |
| `tf-plan`    | Preview infrastructure changes|
| `tf-apply`   | Apply infrastructure changes  |
| `tf-destroy` | Destroy all resources         |
| `tf-fmt`     | Format Terraform files        |
| `whoami`     | Show current AWS identity     |
| `clean`      | Remove Terraform cache files  |

## Project Structure

```
├── environments/      # Environment-specific variables
│   ├── dev.tfvars
│   └── prod.tfvars
├── website/           # Static website files
│   └── index.html
├── main.tf            # Provider configuration
├── website.tf         # S3 website resources
├── variables.tf       # Input variables
├── outputs.tf         # Output values
└── Makefile           # Build automation
```
