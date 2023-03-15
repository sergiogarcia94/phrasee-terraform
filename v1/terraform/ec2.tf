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

  name = "${var.resource_prefix}-instance"

  ami           = data.aws_ami.nginx_instance.id
  instance_type = "t3.micro"

  key_name = aws_key_pair.generated_key.key_name

  monitoring             = true
  vpc_security_group_ids = [module.ec2_nginx_sg.security_group_id]
  subnet_id              = element(module.vpc.public_subnets, 0)

  iam_instance_profile = aws_iam_instance_profile.test_profile.id

  user_data_base64 = base64encode(
    templatefile("templates/userdata.sh.tpl",
      {
        tf_bucket_name         = module.s3_bucket_configs.s3_bucket_id,
        tf_cloudwatch_loggroup = aws_cloudwatch_log_group.nginx_instance.name
        //TF_HTML_FILE           = value,
      }
    )
  )

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
