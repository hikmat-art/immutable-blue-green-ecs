resource "aws_lb" "this" {
	name               = "${var.project_name}-alb"
	load_balancer_type = "application"
	subnets            = var.public_subnet_ids
	security_groups    = [var.alb_sg_id]
}
