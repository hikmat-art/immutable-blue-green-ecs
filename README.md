# Immutable Blue/Green ECS Platform with FinOps Guardrails

Terraform-based AWS ECS Fargate platform implementing immutable Blue/Green deployments with cost controls.

## Features
- ECS Fargate Blue/Green deployment
- ALB weighted traffic switching
- Immutable task definitions
- Private ECS, public ALB
- AWS Budgets & billing alarms
- Terraform-only infrastructure

## Deployment
```bash
terraform init
terraform plan
terraform apply
```

Blue/Green Switch

Change ALB listener weights and apply Terraform.


---
