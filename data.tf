data "aws_ami" "image" {
  most_recent = var.ami_latest
  owners      = [format("%0.10d", var.account_id)]

  filter {
    name   = "name"
    values = [var.ami_name]
  }
}

data "template_file" "userdata" {
  template = base64decode(var.userdata)
}
