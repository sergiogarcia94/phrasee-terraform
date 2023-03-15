# tf module docs: https://registry.terraform.io/modules/terraform-aws-modules/s3-bucket/aws/3.8.2
module "s3_bucket_configs" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.8"


  bucket = "${var.resource_prefix}-configuration-bucket"

  # block all public access
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }
}


//THIS SHOULD BE PART OF THE CD PIPELINE
resource "aws_s3_object" "s3_html_page" {
  bucket = module.s3_bucket_configs.s3_bucket_id
  key    = "/phrasee-terraform/v1/terraform/files/static_web.html"
  source = "files/index.html"

  etag = filemd5("files/index.html")
}
