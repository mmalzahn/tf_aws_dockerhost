locals {
  common_tags {
    responsible     = "${var.tag_responsibel}"
    tf_managed      = 1
    tf_project      = "dca:${terraform.workspace}:${random_string.projectId.result}:${replace(var.project_name," ","")}"
    tf_project_name = "DCA_${replace(var.project_name," ","_")}_${terraform.workspace}"
    tf_environment  = "${terraform.workspace}"
    tf_created      = "${timestamp()}"
    tf_runtime      = "${var.laufzeit_tage}"
    tf_responsible  = "${var.tag_responsibel}"
  }

  projId                = "${random_string.projectId.result}"
  resource_prefix       = "${random_string.projectId.result}-${var.project_name}-${terraform.workspace}-"
  resource_prefix_short = "${random_string.projectId.result}-${terraform.workspace}-"
}

data "terraform_remote_state" "baseInfra" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket}"
    key    = "env:/${terraform.workspace}/${var.remote_state_key}"
    region = "${var.remote_state_bucket_region}"
  }
}

data "aws_ami" "dockerhostPackerAmi" {
  filter {
    name   = "tag:tf_packerid"
    values = ["docker001"]
  }

  owners      = ["681337066511"]
  most_recent = true
}

resource "random_integer" "randomScriptPort" {
  min = 12000
  max = 14000
}

resource "random_string" "projectId" {
  length  = 10
  special = false
  upper   = false
  number  = false
}

resource "random_integer" "randomDockerPort" {
  min = 15001
  max = 16000
}

data "template_file" "installscript" {
  template = "${file("tpl/installdockerhost.tpl")}"

  vars {
    file_system_id = "${element(data.terraform_remote_state.baseInfra.efs_filesystem_id,0)}"
    efs_directory  = "/efs"
    project_id     = "${var.uni_id}"
    user_id        = "${random_string.projectId.result}"
  }
}

data "template_file" "startSshScript" {
  template = "${file("tpl/start_ssh.tpl")}"

  vars {
    random_port      = "${random_integer.randomScriptPort.result}"
    userid           = "${random_string.projectId.result}"
    host_fqdn        = "${aws_route53_record.testmachine_intern.fqdn}"
    bastionhost_fqdn = "${element(data.terraform_remote_state.baseInfra.bastion_dns,0)}"
    workspace        = "${terraform.workspace}"
  }
}

data "template_file" "connectDockerSocket" {
  template = "${file("tpl/connectDocker.tpl")}"

  vars {
    random_port      = "${random_integer.randomDockerPort.result}"
    userid           = "${random_string.projectId.result}"
    host_fqdn        = "${aws_route53_record.testmachine_intern.fqdn}"
    bastionhost_fqdn = "${element(data.terraform_remote_state.baseInfra.bastion_dns,0)}"
    workspace        = "${terraform.workspace}"
  }
}
