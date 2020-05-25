data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_vpc" "selected" {
  id = var.network_vpc_id
}

resource "aws_launch_configuration" "main" {
  name_prefix          = local.prefix
  image_id             = (var.ami_id != "" ? var.ami_id : data.aws_ami.image.id)
  instance_type        = var.instance_type
  iam_instance_profile = var.iam_instance_profile
  enable_monitoring    = var.enable_monitoring
  security_groups      = [var.security_groups]
  user_data            = data.template_file.userdata.rendered
  key_name             = var.admin_key

  root_block_device {
    volume_type = var.volume_type
    volume_size = var.volume_size
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Immutable ASGs are designed for stateless applications and will be replaced in blue/green fashion when the LC is updated
resource "aws_autoscaling_group" "immutable" {
  count = var.immutable_cluster ? 1 : 0

  name                      = aws_launch_configuration.main.name
  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period
  default_cooldown          = var.cooldown
  desired_capacity          = var.desired_capacity
  max_size                  = var.max_size
  min_size                  = var.min_size
  launch_configuration      = aws_launch_configuration.main.id
  vpc_zone_identifier       = [var.subnets]
  protect_from_scale_in     = var.protect_from_scale_in
  #suspended_processes       = [var.asg_suspended_processes]

  # Lookup the value of target group arn, if found use it, if not, return empty string
  target_group_arns = (var.loadbalancer == "" ? var.loadbalancer : split(",", var.loadbalancer))

  tags = local.tags

  lifecycle {
    create_before_destroy = true
  }
}

# Mutable ASGs are designed for stateful applications (e.g. DBs) and will not be destroyed when the LC is updated.
resource "aws_autoscaling_group" "mutable" {
  count = "${! var.immutable_cluster ? 1 : 0}"

  name                      = var.name
  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period
  default_cooldown          = var.cooldown
  desired_capacity          = var.desired_capacity
  max_size                  = var.max_size
  min_size                  = var.min_size
  launch_configuration      = aws_launch_configuration.main.id
  vpc_zone_identifier       = ["${var.subnets}"]
  protect_from_scale_in     = var.protect_from_scale_in
  #suspended_processes       = ["${var.asg_suspended_processes}"]

  # Lookup the value of target group arn, if found use it, if not, return empty string
  target_group_arns = (var.loadbalancer == "" ? var.loadbalancer : split(",", var.loadbalancer))

  tags = local.tags
}