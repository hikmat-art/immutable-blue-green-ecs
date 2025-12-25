variable "project_name" { type = string }
variable "environment" { type = string }
variable "private_subnet_ids" { type = list(string) }
variable "ecs_sg_id" { type = string }
variable "task_execution_role_arn" { type = string }
variable "blue_tg_arn" { type = string }
variable "green_tg_arn" { type = string }
