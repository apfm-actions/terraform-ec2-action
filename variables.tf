locals {
  tags = {
      app : var.github_project,
      env : terraform.workspace,
      repo : var.github_repository
      project : var.project_name,
      owner : var.project_owner,
      email : var.project_email,
      created_by : "terraform-ec2-action"
    }

  prefix       = (var.prefix == "" ? var.name : var.prefix)
  target_group = (var.loadbalancer == "" ? var.loadbalancer : split(",", var.loadbalancer))
}