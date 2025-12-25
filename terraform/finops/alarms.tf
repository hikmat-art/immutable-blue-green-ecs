resource "aws_cloudwatch_metric_alarm" "billing" {
	alarm_name          = "${var.project_name}-billing"
	namespace           = "AWS/Billing"
	metric_name         = "EstimatedCharges"
	statistic           = "Maximum"
	period              = 21600
	evaluation_periods  = 1
	threshold           = var.monthly_budget_usd
	comparison_operator = "GreaterThanThreshold"

	dimensions = {
		Currency = "USD"
	}
}
