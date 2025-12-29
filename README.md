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
IPORTANT NOTICE: Donot forget to apply (terraform destroy command) after successfull test, otherwise you can confront with un wanted AWS resources Costs.
Blue/Green Switch

Change ALB listener weights and apply Terraform.

---

About this project
-------------------

This repository is a focused, production-oriented Terraform implementation of an immutable Blue/Green deployment pattern for AWS ECS on Fargate, with FinOps guardrails baked in. It models a realistic platform you can run in your own AWS account for learning, demonstration, or as the foundation of a small production workload.

Why I built it
-------------

I built this project to demonstrate a practical, maintainable way to deploy containerized applications on AWS with minimal downtime and explicit cost controls. The goal was to show an architecture that: (1) uses immutable deployments to reduce deployment-induced drift and configuration bugs, (2) isolates application workloads in private subnets while exposing a public ALB, and (3) includes basic FinOps measures so teams don’t get surprised by cloud costs.

High-level architecture and data flow
-----------------------------------

- Clients (web browsers or API clients) connect to the public Application Load Balancer (ALB).
- The ALB forwards traffic to one of two target groups: BLUE or GREEN. We use weighted forwarding so traffic can be transitioned between environments gradually.
- Each target group routes to Fargate tasks running in private subnets inside a VPC. Tasks have no public IPs; outbound access uses a NAT Gateway in a public subnet.
- Logs are shipped to CloudWatch (a log group is created), and cost controls are enforced via an AWS Budget and a billing CloudWatch alarm.

Main components
---------------

- Network: VPC, public and private subnets, Internet Gateway, NAT Gateway, route tables.
- Security: Security groups for ALB and ECS, and an IAM role for ECS task execution.
- ALB: Application Load Balancer, two target groups (blue/green), and an HTTP listener with weighted forward actions.
- ECS: Cluster, immutable task definition (Fargate), and two services (blue and green) implemented as separate services so switching is done via ALB weights.
- FinOps: AWS Budgets resource and a billing CloudWatch alarm to notify when spend approaches the monthly budget.

Design decisions and challenges
-------------------------------

- Immutable deployments: Terraform manages immutable task definitions and separate ECS services for blue/green. This avoids in-place mutation of running tasks and simplifies rollbacks.
- Traffic switching: ALB weighted target groups enable a safe, gradual traffic cutover without modifying task counts directly. This avoids race conditions and reduces downtime risk.
- Private tasks with NAT: Placing tasks in private subnets improves security but requires a NAT Gateway for outbound access; this adds cost that the FinOps guardrails help monitor.
- IAM and least privilege: Task execution uses a dedicated IAM role attached with the standard ECS execution policy. In a production rollout, the role should be scoped further to least privilege.

What I learned / overcame
-------------------------

- Modeling blue/green with Terraform requires separating traffic routing from task lifecycle so Terraform can represent both the stable and candidate environments. I used separate ECS services and ALB target groups to make this explicit and safe.
- Networking for Fargate (private subnets + NAT) is straightforward but easy to misconfigure; I added explicit route tables and associations to make the module deterministic.
- Adding FinOps controls early (budgets and alarms) makes it easier to keep the environment cost-conscious during experimentation and demos.

Outcomes
--------

The result is a modular, readable Terraform codebase that can:

- Deploy a small, realistic ECS Fargate platform using blue/green immutable releases.
- Demonstrate controlled traffic switching via ALB weight adjustments.
- Provide basic cost governance via Budgets and a billing alarm.

How to use this repository (quick start)
---------------------------------------

Prerequisites
- An AWS account with credentials configured (AWS CLI or environment variables).
- Terraform 1.5.0 or newer.
- `git` to clone this repository.

Minimal steps
1. Clone the repository and change into the `terraform` directory.

```bash
git clone <repo-url>
cd immutable-blue-green-ecs/terraform
```

2. Initialize Terraform and review the plan.

```bash
terraform init
terraform plan
```

3. Apply to create the demo infrastructure.

```bash
terraform apply
```
NOTICE:
Blue/Green switch
- To shift traffic from BLUE to GREEN, update the ALB listener weights (or update the target group weights in the `alb` module) and run `terraform apply`. For small-scale demos you can also manipulate weights in the AWS console, but for a controlled, auditable flow do it through Terraform and source control.

Recommendations for production hardening
---------------------------------------

- Remote state: Move Terraform state to an S3 backend with DynamoDB locking.
- Secure secrets: Avoid embedding secrets in Terraform files; use SSM Parameter Store or Secrets Manager and reference them securely.
- TLS: Add an ACM certificate and change the ALB listener to HTTPS.
- CI/CD: Add a pipeline (GitHub Actions, GitLab CI, or similar) that runs `terraform fmt`, `terraform validate`, `terraform plan`, and applies in gated stages.
- Monitoring & alerts: Add more CloudWatch metrics, dashboards, and alerts for CPU, memory, and ALB error rates.
- Least privilege: Scope IAM policies to the minimum required actions and resources.
- Cost optimization: Consider using Fargate Spot or autoscaling policies for non-critical workloads and refine budget thresholds.

Educational notes

This project is intentionally modular and explicit so it can be used as a learning artifact. You can:

- Run the full stack in a low-cost test account to observe blue/green switching.
- Modify container images to use lightweight test images and experiment with scaling.
- Inspect CloudWatch logs and the AWS Console to see how traffic moves between target groups.
  
Attribution and next steps.

This repository is my implementation and learning artifact demonstrating immutable blue/green deployments on ECS Fargate with FinOps basics. If you'd like, I can extend this with a CI/CD example, ACM-based TLS, or a secure remote-state backend for production readiness.

Files to review
---------------

- Root module: `terraform/main.tf` — wiring for modules and variables.
- Network: `terraform/network/` — VPC, subnets, NAT, and routing.
- Security: `terraform/security/` — IAM role and security groups.
- ALB: `terraform/alb/` — load balancer, listener, and blue/green target groups.
- ECS: `terraform/ecs/` — cluster, task definition, and blue/green services.
- FinOps: `terraform/finops/` — AWS Budget and billing alarm.
