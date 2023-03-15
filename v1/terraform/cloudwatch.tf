resource "aws_cloudwatch_log_group" "nginx_instance" {
  name = "/ecs/nginx"

  tags = {
    Environment = "production"
    Application = "serviceA"
  }
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "my-dashboard"

  dashboard_body = jsonencode({
    "widgets" = [
      for metric in var.cloudwatchMetricsList : {
        type   = "metric"
        width  = 12
        height = 6
        properties = {
          metrics = [
            [
              "AWS/EC2",
              metric,
              "InstanceId",
              module.ec2_instance.id
            ]
          ]
          period = 300
          stat   = "Average"
          region = "eu-west-1"
          title  = "EC2 Instance CPU"
        }
      }
    ]
  })
}
