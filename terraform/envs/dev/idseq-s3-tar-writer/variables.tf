locals {
  aws_account         = var.aws_accounts.idseq-dev
  aws_profile         = var.aws_profile
  ecr_repo_name       = null
  force_image_rebuild = null
  image_tag           = null
  max_image_count     = null
  region              = var.region
  tags                = {}
}
