locals {
  full_domain = "${var.env}.${var.base_domain}"
}

# TODO: Determine what method to use in the future; the old CZI way, or the newer way in this file
#  Note: Either way, the base_domain should be housed in prod (idseq-prod), and not in sandbox (idseq-dev)
#  Currently: Routes are created by adding the sub_domain (staging.seqtoid.org) to the base_domain (seqtoid.org) by using an additional_provider.
#             The additional_provider points to sandbox (idseq-dev/941377154785), as sandbox owns the base_domain.
#             The additional_provider adds a NS record for the sub_domain into the base_domain route53 zone.
#             IE: This Terraform code adds a NS record to a separate AWS account, and so both AWS accounts need to be configured (provider and additional_provider)
#  Previously: The way it was done before by CZI was to have prod, which owned base_domain, add the NS record from each sub_domain itself
#              That meant that each sub_domain must be deployed first (idseq-newdev, idseq-dev, idseq-staging, idseq-sandbox)
#              Then the base_domain deployed _after_ those sub_domains are deployed, in order to create the NS records based on those sub_domains
#              IE: The Terraform for each sub_domain (idseq-dev, etc...) must be deployed first, and then after that, the base_domain could be deployed (idseq_prod)
#

resource "aws_route53_zone" "env-seqtoid-org" {
  name = local.full_domain
  tags = {
    owner   = var.owner
    project = var.project_v1
    service = "seqtoid"
    env     = var.env
  }
}

data "aws_route53_zone" "root-seqtoid-org" {
  name         = var.base_domain
  private_zone = false
  provider     = aws.czi-si-us-east-1
}

resource "aws_route53_record" "env-seqtoid-org" {
  zone_id  = data.aws_route53_zone.root-seqtoid-org.zone_id
  name     = local.full_domain
  type     = "NS"
  ttl      = 300
  records  = aws_route53_zone.env-seqtoid-org.name_servers
  provider = aws.czi-si-us-east-1
}
