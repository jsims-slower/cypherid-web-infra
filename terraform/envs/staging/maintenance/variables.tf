locals {
  tags = data.aws_default_tags.current.tags
}

data "aws_default_tags" "current" {}
