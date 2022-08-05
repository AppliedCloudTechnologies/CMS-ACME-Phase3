# resource "aws_cloudwatch_dashboard" "ecs_logging" {
#   dashboard_name = "ecs_logging-dashboard"

#   dashboard_body = <<EOF
# {
#   "widgets": [
#     {
#       "type": "metric",
#       "x": 0,
#       "y": 0,
#       "width": 12,
#       "height": 6,
#       "properties": {
#         "metrics": [
#           [
#             "ALX/ECS",
#             "CpuUtilized"
#           ]
#         ],
#         "period": 300,
#         "stat": "Average",
#         "region": "us-east-1",
#         "title": "ECS CPU"
#       }
#     },
#     {
#       "type": "text",
#       "x": 0,
#       "y": 7,
#       "width": 3,
#       "height": 3,
#       "properties": {
#         "markdown": "Ansong CW Dashboard"
#       }
#     }
#   ]
# }
# EOF
# }

# resource "aws_cloudwatch_log_group" "ecs_logging" {
#   name              = "ecs_logging"
#   retention_in_days = 0

#   tags = {
#     Name = "ansong844-cloudwatch-log-group"
#   }
# }

# resource "aws_cloudwatch_log_metric_filter" "ecs_logging" {
#   name           = "Error-Logging"
#   pattern        = "ERROR"
#   log_group_name = aws_cloudwatch_log_group.ecs_logging.name

#   metric_transformation {
#     name      = "EventCount"
#     namespace = "ALX/ECS"
#     value     = "1"
#   }
# }

# resource "aws_cloudwatch_metric_alarm" "ecs_logging" {
#   alarm_name                = "ecs-error-logging"
#   comparison_operator       = "GreaterThanOrEqualToThreshold"
#   evaluation_periods        = "2"
#   metric_name               = "CpuUtilized"
#   namespace                 = "ALX/ECS"
#   period                    = "43200"
#   statistic                 = "Average"
#   threshold                 = "80"
#   insufficient_data_actions = []
# }
