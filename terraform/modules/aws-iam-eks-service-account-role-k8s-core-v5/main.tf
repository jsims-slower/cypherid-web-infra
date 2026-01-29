locals {
  name = "${var.project}-${var.env}-${var.service}"

  tags = {
    managedBy = "terraform"
    Name      = local.name
    project   = var.project
    env       = var.env
    service   = var.service
    owner     = var.owner
  }

  iam_path          = coalesce(var.iam_path, "/${var.eks_cluster_id}/")
  oidc_provider_url = replace(var.oidc_provider_url, "https://", "")
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "assume-role" {
  dynamic "statement" {
    for_each = compact([var.authorize_aws_account_assume_role])
    content {
      principals {
        type        = "AWS"
        identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
      }
      actions = ["sts:AssumeRole", "sts:TagSession"]
    }
  }

  statement {
    principals {
      type = "Federated"

      identifiers = [var.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_provider_url}:sub"
      values   = ["system:serviceaccount:${var.namespace}:${var.service_account_name}"]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]
  }
}

resource "aws_iam_role" "role" {
  name                 = local.name
  description          = "Service account role for ${var.service} in ${var.project}-${var.env}. Owned by ${var.owner}."
  assume_role_policy   = data.aws_iam_policy_document.assume-role.json
  path                 = local.iam_path
  tags                 = local.tags
  max_session_duration = var.max_session_duration
  permissions_boundary = var.role_permissions_boundary_arn
}
