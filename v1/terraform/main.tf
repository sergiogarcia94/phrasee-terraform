terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.55"
    }
  }

  # Target an existing s3 bucket to enable remote state
  backend "s3" {
    bucket = "sgarcia-phrasee-configuration-bucket"
    key    = "phrasee-terraform/v1/terraform/tf.state"
    region = "eu-west-1"
    # Target an existing dynamodb table to enable state locking
    # dynamodb_table  = "dynamodb-state-locking"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}
