# Scale Out Policy
resource "aws_autoscaling_policy" "scale_out" {

  name               = "scale-out"
  scaling_adjustment = 1
  adjustment_type    = "ChangeInCapacity"
  cooldown           = 300

  autoscaling_group_name = aws_autoscaling_group.web_asg.name
}

# Scale In Policy
resource "aws_autoscaling_policy" "scale_in" {

  name               = "scale-in"
  scaling_adjustment = -1
  adjustment_type    = "ChangeInCapacity"
  cooldown           = 300

  autoscaling_group_name = aws_autoscaling_group.web_asg.name
}

# High CPU Alarm
resource "aws_cloudwatch_metric_alarm" "cpu_high" {

  alarm_name = "cpu-high"

  comparison_operator = "GreaterThanThreshold"

  evaluation_periods = 2

  metric_name = "CPUUtilization"

  namespace = "AWS/EC2"

  period = 300

  statistic = "Average"

  threshold = 70

  alarm_actions = [
    aws_autoscaling_policy.scale_out.arn
  ]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }
}

# Low CPU Alarm
resource "aws_cloudwatch_metric_alarm" "cpu_low" {

  alarm_name = "cpu-low"

  comparison_operator = "LessThanThreshold"

  evaluation_periods = 2

  metric_name = "CPUUtilization"

  namespace = "AWS/EC2"

  period = 300

  statistic = "Average"

  threshold = 20

  alarm_actions = [
    aws_autoscaling_policy.scale_in.arn
  ]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }
}