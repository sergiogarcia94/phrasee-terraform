terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.55"
    }
  }

  # If you want to enable remote state target an existing s3 bucket
  backend "s3" {
    bucket = "sgarcia-phrasee-configuration-bucket"
    key    = "phrasee-terraform/v1/terraform/tf.state"
    region = "eu-west-1"
    # If you want to enable locking target an existing dynamodb table
    # dynamodb_table  = "dynamodb-state-locking"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}
