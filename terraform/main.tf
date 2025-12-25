module "network" {
	source = "./network"

	project_name = var.project_name
	environment  = var.environment
}

module "security" {
	source = "./security"

	project_name = var.project_name
	environment  = var.environment
	vpc_id       = module.network.vpc_id
}

module "alb" {
	source = "./alb"

	project_name      = var.project_name
	environment       = var.environment
	vpc_id            = module.network.vpc_id
	public_subnet_ids = module.network.public_subnet_ids
	alb_sg_id         = module.security.alb_sg_id
}

module "ecs" {
	source = "./ecs"

	project_name            = var.project_name
	environment             = var.environment
	private_subnet_ids      = module.network.private_subnet_ids
	ecs_sg_id               = module.security.ecs_sg_id
	task_execution_role_arn = module.security.ecs_task_execution_role_arn
	blue_tg_arn             = module.alb.blue_tg_arn
	green_tg_arn            = module.alb.green_tg_arn
}

module "finops" {
	source = "./finops"

	project_name       = var.project_name
	environment        = var.environment
	monthly_budget_usd = var.monthly_budget_usd
}
