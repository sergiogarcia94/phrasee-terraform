# RSA KEY generation
resource "tls_private_key" "instance_rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_secretsmanager_secret" "instance_pem" {
  name = "/${var.stack_key_path}/rsa1.pem"
}

resource "aws_secretsmanager_secret_version" "instance_pem_value" {
  secret_id     = aws_secretsmanager_secret.instance_pem.id
  secret_string = tls_private_key.instance_rsa.private_key_openssh
}

resource "aws_key_pair" "generated_key" {
  key_name   = local.ssh_key_name
  public_key = tls_private_key.instance_rsa.public_key_openssh
}

# tf module docs: https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/4.17.1
module "ec2_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.17"

  name        = local.sg_name
  description = local.sg_description
  vpc_id      = local.sg_vpc_id

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      description = "all traffic"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "ssh port"
      cidr_blocks = var.external_cidr
    },
    {
      from_port   = var.app_external_port
      to_port     = var.app_external_port
      protocol    = "tcp"
      description = "application port"
      cidr_blocks = var.external_cidr
    }
  ]
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
  name               = local.instance_role_name
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json

  inline_policy {
    name = "s3_get_objects"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "s3:GetObject",
            "s3:GetBucketLocation",
            "s3:GetObjectAttributes"
          ]
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
          Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "logs:DescribeLogStreams",
            "cloudwatch:PutMetricData"
          ]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }
}

resource "aws_iam_instance_profile" "test_profile" {
  name = local.instance_profile_name
  role = aws_iam_role.instance_role.name
}
