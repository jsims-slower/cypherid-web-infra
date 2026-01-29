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

variable "iam_path" {
  type        = string
  default     = ""
  description = "IAM path for the role."
}

variable "role_permissions_boundary_arn" {
  description = "Permissions boundary ARN to use for IAM role"
  type        = string
  default     = ""
}
variable "max_session_duration" {
  description = "Maximum CLI/API session duration in seconds between 3600 and 43200"
  type        = number
  default     = 3600
}

variable "namespace" {
  description = "Kubernetes namespace that the service account is in"
  type        = string
}

variable "service_account_name" {
  description = "Name of the service account"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the OIDC Provider"
  type        = string
}

variable "oidc_provider_url" {
  description = "URL of the OIDC Provider"
  type        = string
}

variable "authorize_aws_account_assume_role" {
  type        = bool
  description = "Should the role's trust relationship include the current AWS account."
  default     = null
}
