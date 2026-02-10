locals {
  eks_cluster = data.terraform_remote_state.eks.outputs
  tags        = data.aws_default_tags.current.tags
  additional_addons = {
    # datadog = {
    #   mute                 = true
    #   api_key              = data.aws_ssm_parameter.dd_api_key.value
    #   ops_genie_owner_team = var.ie_ops_genie_team
    # }
  }
}

data "aws_default_tags" "current" {}
