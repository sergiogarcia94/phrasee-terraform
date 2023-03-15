aws_region = "eu-west-1"

## Tagging
environment    = "phrasee-challenge"
cost_center    = "phrasee-challenge"
stack          = "nginx"
stack_key_path = "phrasee-terraform/v1/terraform"

## Networking vars
create_networking = true

# You must fill these values if you are not creating the networking resources
#external_vpc_id            = "vpc-0e17b710461b4910e"
#external_public_subnet_id  = "subnet-02aeef3a1e50ccade"
#external_private_subnet_id = "subnet-07eb5973dfe5f4e13"

vpc_cidr            = "10.20.0.0/16"
vpc_azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
vpc_private_subnets = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24"]
vpc_public_subnets  = ["10.20.101.0/24", "10.20.102.0/24", "10.20.103.0/24"]
create_igw          = true

## S3 vars
bucket_versioning = true

## Security
external_cidr = "2.153.41.170/32"

## Observability
log_group_name = "/ec2/nginx"
cloudwatchEC2MetricList = [
  "CPUUtilization",
  "NetworkIn",
  "NetworkOut",
  "NetworkPacketsIn",
  "NetworkPacketsOut",
  "StatusCheckFailed",
  "StatusCheckFailed_Instance",
  "StatusCheckFailed_System"
]

cloudwatchDockerMetricList = [
  "Memory",
  "CPU"
]

naming_prefix = "sgarcia-phrasee"

# App config
app_external_port = 8080
