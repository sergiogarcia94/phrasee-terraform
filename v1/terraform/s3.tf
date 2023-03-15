# module docs: https://registry.terraform.io/modules/terraform-aws-modules/s3-bucket/aws/3.8.2
module "s3_bucket_configs" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.8"

  bucket = local.bucket_name

  # block all public access
  block_public_acls       = var.bucket_block_public_access
  block_public_policy     = var.bucket_block_public_access
  ignore_public_acls      = var.bucket_block_public_access
  restrict_public_buckets = var.bucket_block_public_access

  versioning = {
    enabled = var.bucket_versioning
  }
  tags = merge(local.common_tags, var.bucket_tags)
}


# THIS IS PART OF THE CD PIPELINE
resource "aws_s3_object" "s3_html_page" {
  bucket = module.s3_bucket_configs.s3_bucket_id
  key    = "/phrasee-terraform/v1/terraform/files/static_web.html"
  source = "files/index.html"

  etag = filemd5("files/index.html")
}
