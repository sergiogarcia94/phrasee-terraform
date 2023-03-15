locals {

  # Netwworking
  vpc_name = var.vpc_name != "" ? var.vpc_name : "${var.naming_prefix}-vpc"

  # S3
  bucket_name = var.bucket_name != "" ? var.bucket_name : "${var.naming_prefix}-configuration-bucket"

  # EC2
  ec2_instance_name      = var.instance_name != "" ? var.instance_name : "${var.naming_prefix}-instance"
  ec2_instance_subnet_id = var.create_networking ? element(module.vpc.0.public_subnets, 0) : var.external_public_subnet_id

  # Security
  ssh_key_name          = var.ssh_key_name != "" ? var.ssh_key_name : "${var.naming_prefix}-instance-key"
  sg_name               = var.sg_name != "" ? var.sg_name : "${var.naming_prefix}-instance-sg"
  sg_description        = var.sg_description != "" ? var.sg_description : "Security Group for ${var.stack} instance"
  sg_vpc_id             = var.create_networking ? module.vpc.0.vpc_id : var.external_vpc_id
  instance_role_name    = var.instance_role_name != "" ? var.instance_role_name : "${var.naming_prefix}-instance-role"
  instance_profile_name = var.instance_profile_name != "" ? var.instance_profile_name : "${var.naming_prefix}-instance-profile"

  # observability
  cw_dashboard_name = var.cw_dashboard_name != "" ? var.cw_dashboard_name : "${var.naming_prefix}-dashboard"

  common_tags = {
    Terraform   = "true",
    Environment = var.environment,
    CostCenter  = var.cost_center,
    Stack       = var.stack
  }
}
