resource "aws_lb_target_group" "blue" {
	name        = "${var.project_name}-blue"
	port        = 80
	protocol    = "HTTP"
	target_type = "ip"
	vpc_id      = var.vpc_id
}

resource "aws_lb_target_group" "green" {
	name        = "${var.project_name}-green"
	port        = 80
	protocol    = "HTTP"
	target_type = "ip"
	vpc_id      = var.vpc_id
}
