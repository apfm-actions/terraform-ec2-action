data "aws_ami" "image" {
  most_recent = var.ami_latest
  owners      = [var.ami_owner]

  filter {
    name   = "name"
    values = [var.ami_name]
  }
}

data "template_file" "userdata" {
  template = "${var.userdata}"
}
