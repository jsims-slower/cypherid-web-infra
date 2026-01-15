module "terraform-aws-tfstate-backend" {
  source                      = "git@github.com:cloudposse/terraform-aws-tfstate-backend?ref=1.4.0"
  dynamodb_enabled            = var.dynamodb_enabled
  # prevent_unencrypted_uploads = var.prevent_unencrypted_uploads
  s3_bucket_name              = var.s3_bucket_name
}
