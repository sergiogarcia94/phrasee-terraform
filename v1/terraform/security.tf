resource "tls_private_key" "nginx_instance_rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_secretsmanager_secret" "nginx_instance_pem" {
  name = "/phrasee-terraform/v1/terraform/rsa.pem"
}

resource "aws_secretsmanager_secret_version" "nginx_instance_pem_value" {
  secret_id     = aws_secretsmanager_secret.nginx_instance_pem.id
  secret_string = tls_private_key.nginx_instance_rsa.private_key_openssh
}

resource "aws_key_pair" "generated_key" {
  key_name   = "${var.resource_prefix}-instance-key"
  public_key = tls_private_key.nginx_instance_rsa.public_key_openssh
}

# tf module docs: https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/4.17.1
module "ec2_nginx_sg" {
  source  = "terraform-aws-modules/security-group/aws//modules/http-80"
  version = "~> 4.17"

  name        = "${var.resource_prefix}-instance"
  description = "Security group for EC2 instance running Nginx"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["10.20.30.40/32"]
}


data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "instance_role" {
  name               = "${var.resource_prefix}-instance-role"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json

  inline_policy {
    name = "s3_get_objects"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["s3:GetObject", "s3:GetBucketLocation", "s3:GetObjectAttributes"]
          Effect   = "Allow"
          Resource = "arn:aws:s3:::${module.s3_bucket_configs.s3_bucket_id}/*"
        },
      ]
    })
  }

  inline_policy {
    name = "cloudwatch_manage_logs"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents", "logs:DescribeLogStreams", "cloudwatch:PutMetricData"]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }
}

resource "aws_iam_instance_profile" "test_profile" {
  name = "${var.resource_prefix}-instance-profile"
  role = aws_iam_role.instance_role.name
}
