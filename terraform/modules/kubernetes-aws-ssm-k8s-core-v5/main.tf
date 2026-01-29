locals {
  metrics_port = "9999"
  name         = "${var.project}-${var.env}-${var.service}"
  replicas     = "1"
}

data "aws_region" "current" {} // the AWS region configured on the provider

module "service-account-role" {
  source               = "../aws-iam-eks-service-account-role-k8s-core-v5"
  project              = var.project
  env                  = var.env
  service              = var.service
  owner                = var.owner
  eks_cluster_id       = var.eks_cluster_id
  iam_path             = var.iam_role_path
  oidc_provider_url    = var.cluster_oidc_issuer_url
  oidc_provider_arn    = var.oidc_provider_arn
  namespace            = var.namespace
  service_account_name = var.service
}

data "aws_iam_policy_document" "policy" {
  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/allowAwsSsmRoleAssume"
      values   = ["true"]
    }
  }
}

resource "aws_iam_role_policy" "policy" {
  name   = "${local.name}-policy"
  role   = module.service-account-role.iam_role
  policy = data.aws_iam_policy_document.policy.json
}

resource "kubernetes_deployment" "kubernetes-aws-ssm" {
  metadata {
    labels = {
      app = var.service
    }

    name      = var.service
    namespace = var.namespace
  }

  spec {
    replicas = local.replicas

    selector {
      match_labels = {
        app = var.service
      }
    }

    strategy {
      rolling_update {
        max_surge       = "25%"
        max_unavailable = "25%"
      }

      type = "RollingUpdate"
    }

    template {

      metadata {
        labels = {
          app = var.service
        }
      }

      spec {
        service_account_name            = kubernetes_service_account.aws-ssm.metadata[0].name
        automount_service_account_token = true

        container {
          name              = var.service
          image             = "${var.image_name}:${var.image_tag}"
          image_pull_policy = "Always"

          port {
            name           = "http"
            container_port = local.metrics_port
          }

          env {
            name  = "AWS_REGION"
            value = data.aws_region.current.name
          }

          liveness_probe {
            initial_delay_seconds = 30
            timeout_seconds       = 3

            http_get {
              path = "/healthz"
              port = local.metrics_port
            }
          }

          readiness_probe {
            initial_delay_seconds = 15
            timeout_seconds       = 3

            http_get {
              path = "/healthz"
              port = local.metrics_port
            }
          }

          resources {
            limits = {
              cpu    = "100m"
              memory = "300Mi"
            }

            requests = {
              cpu    = "100m"
              memory = "100Mi"
            }
          }

          env {
            name  = "METRICS_URL"
            value = "0.0.0.0:${local.metrics_port}"
          }
        }
      }
    }
  }
}

resource "kubernetes_service_account" "aws-ssm" {
  metadata {
    name      = var.service
    namespace = var.namespace

    annotations = {
      "eks.amazonaws.com/role-arn" = module.service-account-role.iam_role_arn
    }
  }
}

resource "kubernetes_cluster_role" "aws-ssm" {
  metadata {
    name = var.service
  }

  rule {
    api_groups = [""]
    resources  = ["configmaps", "secrets"]
    verbs      = ["create", "get", "list", "update", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["pods"]
    verbs      = ["get", "list"]
  }
}

resource "kubernetes_cluster_role_binding" "aws-ssm" {
  metadata {
    name = var.service
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.aws-ssm.metadata[0].name
  }

  subject {
    api_group = ""
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.aws-ssm.metadata[0].name
    namespace = var.namespace
  }
}
