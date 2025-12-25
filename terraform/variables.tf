variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "immutable-blue-green-ecs"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "monthly_budget_usd" {
  type    = number
  default = 50
}
