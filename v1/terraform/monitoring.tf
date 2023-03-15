resource "aws_cloudwatch_log_group" "nginx_instance" {
  name = var.log_group_name

  tags = local.common_tags
}

resource "aws_cloudwatch_dashboard" "instance_dashboard" {
  dashboard_name = local.cw_dashboard_name

  dashboard_body = jsonencode({
    "widgets" = concat(
      [
        for metric in var.cloudwatchEC2MetricList : {
          type   = "metric"
          width  = var.cw_widget_width
          height = var.cw_widget_height
          properties = {
            metrics = [
              [
                "AWS/EC2",
                metric,
                "InstanceId",
                module.ec2_instance.id
              ]
            ]
            period = var.cw_widget_period
            stat   = "Average"
            region = var.aws_region
            title  = "${var.stack} Instance ${metric}"
          }
        }
      ],
      [
        for metric in var.cloudwatchDockerMetricList : {
          type   = "metric"
          width  = var.cw_widget_width
          height = var.cw_widget_height
          properties = {
            metrics = [
              [
                "DockerStats",
                metric,
                "ContainerName",
                "nginx",
                "InstanceId",
                module.ec2_instance.id
              ]
            ]
            period = var.cw_widget_period
            stat   = "Average"
            region = var.aws_region
            title  = "${var.stack} Docker ${metric}"
          }
        }
      ]
    )
  })
}
