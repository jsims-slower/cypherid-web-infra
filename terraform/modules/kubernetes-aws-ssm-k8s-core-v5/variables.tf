variable "owner" {
  type        = string
  description = "Owner for tagging and naming. See [doc](../README.md#consistent-tagging)."
}

variable "project" {
  type        = string
  description = "Project for tagging and naming. See [doc](../README.md#consistent-tagging)"
}

variable "service" {
  type        = string
  description = "Service for tagging and naming. See [doc](../README.md#consistent-tagging)."
}

variable "env" {
  type        = string
  description = "Env for tagging and naming. See [doc](../README.md#consistent-tagging)."
}

variable "eks_cluster_id" {
  description = "The name/id of the EKS cluster."
  type        = string
}

variable "image_name" {
  type    = string
  default = "626314663667.dkr.ecr.us-west-2.amazonaws.com/aws-ssm"
}

variable "image_tag" {
  type    = string
  default = "arm64"
}

variable "namespace" {
  description = "Kubernetes namespace for all resources"
  type        = string
}

variable "iam_role_path" {
  type        = string
  description = "IAM Path for the IAM role created for the service. If omitted, defaults to /{eks_cluster_id}-{service}/"
  default     = ""
}

variable "cluster_oidc_issuer_url" {
  type        = string
  description = "The URL on the EKS cluster OIDC Issuer"
}

variable "oidc_provider_arn" {
  type        = string
  description = "The ARN of the EKS cluster OIDC provider"
}
