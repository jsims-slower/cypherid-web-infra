locals {
  owner_roles = [
    # "poweruser", // TODO - Where are these created, and are they necessary? Appear to be deployed via terraform from 'shared-infra'. For now, manually created a 'poweruser' IAM role that matches what is in the CZI dev account.
    "AWSReservedSSO_AWSAdministratorAccess_f655aa408ec10f58", // SSO role used when locally applying terraform with an SSO profile
    #"gha-seqtoid" // Role used by GH Actions for applying terraform (cypherid-infra & cypherid-web-infra)
    # "okta-czi-admin",
    # "tfe-si"
  ]

  cluster_name            = var.eks_cluster_name
  iam_cluster_name_prefix = ""

  tags            = var.tags
  vpc_id          = data.terraform_remote_state.cloud-env.outputs.vpc_id
  subnet_ids      = data.terraform_remote_state.cloud-env.outputs.private_subnets
  cluster_version = "1.30"

  node_groups = {
    "arm" = {
      max_servers   = 20
      capacity_type = "ON_DEMAND"
      architecture = {
        ami_type       = "AL2_ARM_64"
        instance_types = ["t4g.xlarge"]
      }
    },
    // please push teams to use ARM, this is just a backup in case you need it
    "x86" = {
      max_servers   = 10
      capacity_type = "ON_DEMAND"
      architecture = {
        ami_type       = "AL2_x86_64"
        instance_types = ["t3.xlarge"]
      }
    }
  }
  authorized_github_repos = {
    chanzuckerberg = ["czid-graphql-federation-server"]
  }
  addons = {
    enable_guardduty = true
  }
}
