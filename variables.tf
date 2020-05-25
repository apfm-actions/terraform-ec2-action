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
    
  launch_config_tags = "${concat(local.default_lc_tags, var.launch_config_tags)}"

  prefix       = (var.prefix == "" ? var.name : var.prefix)
  target_group = (var.loadbalancer == "" ? var.loadbalancer : split(",", var.loadbalancer))
}