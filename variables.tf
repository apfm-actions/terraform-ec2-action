locals {
  default_lc_tags = [
    {
      key                 = "Name"
      value               = "${var.name}"
      propagate_at_launch = true
    },
    {
      key                 = "App"
      value               = "${var.name}"
      propagate_at_launch = true
    },
    {
      key                 = "Env"
      value               = "${terraform.workspace}"
      propagate_at_launch = true
    }
  ]
  launch_config_tags = "${concat(local.default_lc_tags, var.launch_config_tags)}"

  prefix       = (var.prefix == "" ? var.name : var.prefix)
  target_group = "${lookup(var.loadbalancer, "target_group_arn", "")}"
}