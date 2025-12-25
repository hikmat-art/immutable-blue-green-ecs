resource "aws_ecs_service" "green" {
	name            = "${var.project_name}-green"
	cluster         = aws_ecs_cluster.this.id
	task_definition = aws_ecs_task_definition.app.arn
	desired_count   = 0
	launch_type     = "FARGATE"

	network_configuration {
		subnets         = var.private_subnet_ids
		security_groups = [var.ecs_sg_id]
		assign_public_ip = false
	}

	load_balancer {
		target_group_arn = var.green_tg_arn
		container_name   = "app"
		container_port   = 80
	}

	lifecycle {
		ignore_changes = [desired_count]
	}
}
