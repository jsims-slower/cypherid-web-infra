locals {
  attributes                  = ["state"]
  billing_mode                = "PAY_PER_REQUEST"
  dynamodb_enabled            = var.dynamodb_enabled
  environment                 = "staging"
  name                        = "idseq-infra-staging"
  namespace                   = "${var.tags.project}-staging-${var.tags.service}"
  s3_bucket_name              = var.s3_bucket_name
  prevent_unencrypted_uploads = var.prevent_unencrypted_uploads
  stage                       = var.env
  tags                        = var.tags
  terraform_version           = "1.3.6"
}
