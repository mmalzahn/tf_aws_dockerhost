locals {
  common_tags {
    responsible     = "${var.tag_responsibel}"
    tf_managed      = "1"
    tf_project      = "dca:${terraform.workspace}:${random_id.randomPart.b64_url}:${replace(var.project_name," ","")}"
    tf_project_name = "DCA_${replace(var.project_name," ","_")}_${terraform.workspace}"
    tf_environment  = "${terraform.workspace}"
    tf_created      = "${timestamp()}"
    tf_runtime      = "${var.laufzeit_tage}"
    tf_responsible  = "${var.tag_responsibel}"
    tf_configId     = "${random_id.configId.b64_url}"
  }

  projId          = "${random_string.dnshostname.result}"
  resource_prefix = "${random_id.randomPart.b64_url}-${var.project_name}-${terraform.workspace}-"
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
    values = ["docker002"]
  }

  owners      = ["681337066511"]
  most_recent = true
}
resource "random_integer" "randomScriptPort" {
  min   = 12000
  max   = 14000
}

resource "random_string" "dnshostname" {
  length  = 10
  special = false
  upper   = false
  number  = false
}

resource "random_id" "configId" {
  byte_length = 16
}

resource "random_id" "randomPart" {
  byte_length = 4
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
    user_id        = "${lower(random_string.dnshostname.result)}"
  }
}

data "template_file" "startSshScript" {
  count    = "${var.anzahlInstanzen}"
  template = "${file("tpl/start_ssh.tpl")}"

  vars {
    random_port      = "${element(random_integer.randomScriptPort.*.result,count.index)}"
    userid           = "${random_string.dnshostname.result}"
    host_fqdn        = "${element(aws_route53_record.testmachine.*.fqdn,count.index)}"
    bastionhost_fqdn = "${element(data.terraform_remote_state.baseInfra.bastion_dns,0)}"
  }
}

data "template_file" "connectDockerSocket" {
  template = "${file("tpl/connectDocker.tpl")}"

  vars {
    random_port      = "${random_integer.randomDockerPort.result}"
    userid           = "${random_string.dnshostname.result}"
    host_fqdn        = "${aws_route53_record.testmachine.fqdn}"
    bastionhost_fqdn = "${element(data.terraform_remote_state.baseInfra.bastion_dns,0)}"
    workspace        = "${terraform.workspace}"
  }
}