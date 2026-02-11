locals {
  allow_lambda_pull   = false
  ecr_resource_policy = null
  force_delete        = true
  lifecycle_policy    = ""
  max_image_count     = 10 # 100 in cztack//aws-ecr-repo
  name                = "idseq-s3-tar-writer"
  read_arns           = []
  scan_on_push        = false
  tag_mutability      = true
  tags                = data.aws_default_tags.current.tags
  write_arns          = []
}

data "aws_default_tags" "current" {}
