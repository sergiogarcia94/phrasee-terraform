# module docs: https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/3.19.0
module "vpc" {
  count = var.create_networking ? 1 : 0

  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.19"

  name = local.vpc_name
  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_nat_gateway = var.enable_nat_gateway
  create_igw         = var.create_igw

  tags = merge(local.common_tags, var.vpc_tags)
}
