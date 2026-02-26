data "aws_iam_policy_document" "downloads-assume-role" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "downloads" {
  name               = "idseq-downloads-${var.env}"
  description        = "task role for downloads task in ${var.env} environment"
  assume_role_policy = data.aws_iam_policy_document.downloads-assume-role.json
}

module "downloads_iam_policy" {
  source = "../../../modules/aws-iam-policy-s3-writer-v0.66.0"

  bucket_name   = var.s3_bucket_samples
  bucket_prefix = ""

  env       = var.env
  owner     = var.owner
  project   = var.project
  role_name = aws_iam_role.downloads.name
  service   = var.component
}

resource "aws_iam_role" "downloads_v1" {
  name               = "czi-infectious-disease-downloads-${var.env}"
  description        = "downloads v1 task role for downloads task"
  assume_role_policy = data.aws_iam_policy_document.downloads-assume-role.json
}

module "downloads_v1_iam_policy" {
  source = "../../../modules/aws-iam-policy-s3-writer-v0.66.0"

  bucket_name   = var.s3_bucket_samples_v1
  bucket_prefix = ""

  env       = var.env
  owner     = var.owner
  project   = var.project
  role_name = aws_iam_role.downloads_v1.name
  service   = var.component
}

# The "czi-infectious-disease-downloads-${var.env}" task role also needs access to the old samples bucket to read the src_urls of an ECS bulk download.
module "downloads_v1_iam_policy_for_old_samples_bucket" {
  source = "../../../modules/aws-iam-policy-s3-writer-v0.66.0"

  bucket_name   = var.s3_bucket_samples
  bucket_prefix = ""

  env       = var.env
  owner     = var.owner
  project   = var.project
  role_name = aws_iam_role.downloads_v1.name
  service   = var.component
}

resource "aws_iam_role" "aegea-ecs" {
  name               = "aegea.ecs"
  description        = "undocumented but required role needed by the idseq-${var.env}-web ECS Service"
  assume_role_policy = data.aws_iam_policy_document.downloads-assume-role.json
}

resource "aws_iam_role_policy_attachment" "aegea-ecs-ec2-role-policy-attach" {
  role       = aws_iam_role.aegea-ecs.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "aegea-ecs-batch-role-policy-attach" {
  role       = aws_iam_role.aegea-ecs.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
}

resource "aws_security_group" "aegea-ecs-sg" {
  name        = "aegea.ecs"
  description = "undocumented but required Security Group needed by Downloads from the idseq-${var.env}-web ECS Service"
  vpc_id      = data.terraform_remote_state.cloud-env.outputs.vpc_id
  tags = {
    Name = "aegea.ecs"
  }
}

resource "aws_vpc_security_group_egress_rule" "aegea-ecs-allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.aegea-ecs-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
