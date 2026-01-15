terraform {
  backend "local" {
    # path = ".terraform/terraform.tfstate"
    path = "local.tfstate"
  }
}
