resource "aws_security_group" "SG_SSH_IN_extern" {
  count       = "${var.external ? 1 : 0 }"
  name        = "${local.resource_prefix}SG_SSH_IN_extern"
  description = "Allow SSH Management inbound traffic fuer Projekt ${var.project_name}"
  vpc_id      = "${data.terraform_remote_state.baseInfra.vpc_id}"

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65534
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    ignore_changes = ["tags.tf_created"]
  }

  tags = "${merge(local.common_tags,
            map(
              "Name", "${local.resource_prefix}SG_SSH_IN_extern"
              )
              )}"
}

resource "aws_security_group" "SG_SSH_IN_intern" {
  count       = "${var.external ? 0 : 1}"
  name        = "${local.resource_prefix}SG_SSH_IN_intern"
  description = "Allow SSH Management inbound traffic fuer Projekt ${var.project_name}"
  vpc_id      = "${data.terraform_remote_state.baseInfra.vpc_id}"

  ingress {
    from_port       = "22"
    to_port         = "22"
    protocol        = "tcp"
    security_groups = ["${data.terraform_remote_state.baseInfra.bastion_sg}"]
  }

  egress {
    from_port   = 0
    to_port     = 65534
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    ignore_changes = ["tags.tf_created"]
  }

  tags = "${merge(local.common_tags,
            map(
              "Name", "${local.resource_prefix}SG_SSH_IN_intern"
              )
              )}"
}

resource "aws_security_group" "SG_Docker_IN_intern" {
  name        = "${local.resource_prefix}SG_Docker_IN_intern"
  description = "Allow Docker Socket inbound traffic fuer Projekt ${var.project_name}"
  vpc_id      = "${data.terraform_remote_state.baseInfra.vpc_id}"

  ingress {
    from_port       = "2375"
    to_port         = "2375"
    protocol        = "tcp"
    security_groups = ["${data.terraform_remote_state.baseInfra.bastion_sg}"]
  }

  egress {
    from_port   = 0
    to_port     = 65534
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    ignore_changes = ["tags.tf_created"]
  }

  tags = "${merge(local.common_tags,
            map(
              "Name", "${local.resource_prefix}SG_Docker_IN_intern"
              )
              )}"
}
