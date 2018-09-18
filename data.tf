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
