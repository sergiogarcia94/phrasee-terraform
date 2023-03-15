data "aws_ami" "nginx_instance" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10*"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}


# tf module docs: https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/4.3.0
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 4.3"

  name = local.ec2_instance_name

  ami           = var.instance_ami != "" ? var.instance_ami : data.aws_ami.nginx_instance.id
  instance_type = var.instance_type

  key_name = aws_key_pair.generated_key.key_name

  monitoring             = true
  vpc_security_group_ids = [module.ec2_nginx_sg.security_group_id]
  subnet_id              = local.ec2_instance_subnet_id

  iam_instance_profile = aws_iam_instance_profile.test_profile.id

  user_data_base64 = base64encode(
    templatefile("templates/userdata.sh.tpl",
      {
        tf_bucket_name         = module.s3_bucket_configs.s3_bucket_id,
        tf_cloudwatch_loggroup = aws_cloudwatch_log_group.nginx_instance.name
        tf_aws_region          = var.aws_region,
        tf_app_external_port   = var.app_external_port
        tf_stack_key_path      = var.stack_key_path
      }
    )
  )

  tags = merge(local.common_tags, var.instance_tags)
}
