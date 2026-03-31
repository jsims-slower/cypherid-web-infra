output "task_role_arn" {
  value = aws_iam_role.idseq-web.arn
}

output "s3_bucket_workflows" {
  value = local.s3_bucket_workflows
}
