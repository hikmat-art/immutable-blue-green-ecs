resource "aws_cloudwatch_log_group" "ecs" {
	name              = "/ecs/${var.project_name}"
	retention_in_days = 7
}

resource "aws_ecs_task_definition" "app" {
	family                   = "${var.project_name}-task"
	network_mode             = "awsvpc"
	requires_compatibilities = ["FARGATE"]
	cpu                      = "256"
	memory                   = "512"
	execution_role_arn       = var.task_execution_role_arn

	container_definitions = jsonencode([{
		name  = "app"
		image = "nginx:latest"
		essential = true

		portMappings = [{
			containerPort = 80
		}]

		logConfiguration = {
			logDriver = "awslogs"
			options = {
				awslogs-group         = aws_cloudwatch_log_group.ecs.name
				awslogs-region        = "us-east-1"
				awslogs-stream-prefix = "ecs"
			}
		}
	}])
}
