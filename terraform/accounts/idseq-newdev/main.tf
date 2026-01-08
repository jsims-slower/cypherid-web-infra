module "aws-params-secrets-setup" {
  source  = "github.com/chanzuckerberg/cztack//aws-params-secrets-setup?ref=v0.103.2"
  owner   = var.owner
  project = var.project
}
