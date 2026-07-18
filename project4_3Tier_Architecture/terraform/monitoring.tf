resource "aws_sns_topic" "alerts" {
  name = "devops-alerts"
}

# Create Email Subscription
resource "aws_sns_topic_subscription" "email_alert" {

  topic_arn = aws_sns_topic.alerts.arn

  protocol = "email"

  endpoint = "riaandrichard@gmail.com"
}

# Create CPU Alarm for Web ASG Instances
resource "aws_cloudwatch_metric_alarm" "high_cpu" {

  alarm_name = "HighCPU-Web-ASG"

  comparison_operator = "GreaterThanThreshold"

  evaluation_periods = 2

  metric_name = "CPUUtilization"

  namespace = "AWS/EC2"

  period = 300

  statistic = "Average"

  threshold = 70

  alarm_description = "Triggered when CPU exceeds 70%"

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }
}

# Create RDS CPU Alarm
resource "aws_cloudwatch_metric_alarm" "rds_cpu" {

  alarm_name = "HighCPU-RDS"

  comparison_operator = "GreaterThanThreshold"

  evaluation_periods = 2

  metric_name = "CPUUtilization"

  namespace = "AWS/RDS"

  period = 300

  statistic = "Average"

  threshold = 70

  alarm_description = "RDS CPU above 70%"

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.mysql.id
  }
}

# 