module "aws-ecr-repo" {
  source = "git@github.com:chanzuckerberg/cztack//aws-ecr-repo?ref=v0.104.2"

  force_delete    = local.force_delete
  max_image_count = var.max_image_count
  name            = var.ecr_repo_name
  tags            = {}
}

# local-exec for build and push of docker image
resource "null_resource" "build_push_docker_img" {
  triggers = {
    detect_docker_source_changes = var.force_image_rebuild == true ? timestamp() : local.docker_img_src_sha256
  }
  provisioner "local-exec" {
    command = local.docker_build_cmd
  }
}

output "trigged_by" {
  value = null_resource.build_push_docker_img.triggers
}
