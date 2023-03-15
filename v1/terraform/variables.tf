########### Tagging
variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "naming_prefix" {
  type        = string
  description = "This string will be add as a prefix to all aws resouces names"
  default     = ""
}

variable "environment" {
  type        = string
  description = "Name of the environment where this will be deployed"
  default     = ""
}

variable "cost_center" {
  type        = string
  description = "Cost center associated to these resources"
  default     = ""
}

variable "stack" {
  type        = string
  description = "Name of the component or application that will be deployed"
  default     = ""
}

variable "stack_key_path" {
  type        = string
  description = "This string must match the name and directory structure of this repository for traceability"
  default     = ""
}

variable "instance_tags" {
  type        = map(string)
  description = "List of EC2 exclusive tags"
  default     = {}
}

variable "vpc_tags" {
  type        = map(string)
  description = "List of VPC exclusive tags"
  default     = {}
}

variable "bucket_tags" {
  type        = map(string)
  description = "List of S3 exclusive tags"
  default     = {}
}


########### Networking
variable "create_networking" {
  type        = bool
  description = "Set this to true to create the VPC and the required networking resources. For more info check: https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/3.19.0"
  default     = false
}

variable "vpc_name" {
  type        = string
  description = "Name for the vpc resource"
  default     = ""
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR of the VPC"
  default     = "10.0.0.0"
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Set this to true to create a NAT GW during the network creation"
  default     = false
}

variable "create_igw" {
  type        = bool
  description = "Set this to true to create an IG GW during the network creation"
  default     = false
}

variable "vpc_azs" {
  type        = list(string)
  description = "List of availability zones to use during VPC provisioning"
  default     = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "vpc_private_subnets" {
  type        = list(string)
  description = "List of CIDR's to use for private subnets during VPC provisioning"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "vpc_public_subnets" {
  type        = list(string)
  description = "List of CIDR's to use for public subnets during VPC provisioning"
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "external_vpc_id" {
  type        = string
  description = "You should use this variable if you are not using create_networking"
  default     = ""
}

variable "external_public_subnet_id" {
  type        = string
  description = "You should use this variable if you are not using create_networking"
  default     = ""
}

variable "external_private_subnet_id" {
  type        = string
  description = "You should use this variable if you are not using create_networking"
  default     = ""
}

########### S3
variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket"
  default     = ""
}

variable "bucket_block_public_access" {
  type        = bool
  description = "Set this to true to block all public access to the S3 bucket"
  default     = true
}

variable "bucket_versioning" {
  type        = bool
  description = "Set this to true to enable versioning for the S3 bucket"
  default     = false
}

########### EC2
variable "instance_name" {
  type        = string
  description = "Name of the EC2 instance"
  default     = ""
}

variable "instance_ami" {
  type        = string
  description = "AMI id to use during the EC2 instance creation. Leave it empty to use the latest amazon-linux AMI"
  default     = ""
}

variable "instance_type" {
  type        = string
  description = "Instance type for EC2"
  default     = "t3.micro"
}

########### Security
variable "ssh_key_name" {
  type        = string
  description = "Name of the RSA key for SSH"
  default     = ""
}

variable "sg_name" {
  type        = string
  description = "Name of the security group for the EC2 instance"
  default     = ""
}

variable "sg_description" {
  type        = string
  description = "Security group description"
  default     = ""
}

variable "external_cidr" {
  type        = string
  description = "CIDR to add to the security group to allow access to the EC2 instance"
  default     = ""
}

variable "instance_role_name" {
  type        = string
  description = "IAM role for EC2 instance"
  default     = ""
}

variable "instance_profile_name" {
  type        = string
  description = "IAM instance profile to EC2 instance"
  default     = ""
}

########### observability
variable "cloudwatchMetricsList" {
  type        = list(string)
  description = "List of metrics to add to cloudwatch dashboard"
  default     = []
}

variable "log_group_name" {
  type        = string
  description = "Cloudwatch Log Group name"
  default     = ""
}

variable "cw_dashboard_name" {
  type        = string
  description = "Cloudwatch dashboard name"
  default     = ""
}

variable "cw_widget_width" {
  type        = number
  description = "Cloudwatch widget default width"
  default     = 12
}

variable "cw_widget_height" {
  type        = number
  description = "Cloudwatch widget default height"
  default     = 6
}

variable "cw_widget_period" {
  type        = number
  description = "Cloudwatch widget default period"
  default     = 300
}

########### App
variable "app_external_port" {
  type        = number
  description = "External port for nginx service"
  default     = 80
}
