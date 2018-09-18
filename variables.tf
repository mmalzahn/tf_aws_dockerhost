variable "aws_region" {}

variable "remote_state_bucket" {
  default = ""
}

variable "remote_state_key" {
  default = "baseinfrastruktur.state"
}

variable "remote_state_bucket_region" {
  default = ""
}

variable "project_name" {}

variable "uni_id" {}


variable "instance_type" {
  default = "t2.micro"
}

variable "dns_domain" {
  default = "dca-poc.de"
}

variable "tag_responsibel" {}

variable "laufzeit_tage" {
  default = "60"
}

variable "external" {
  default = false
}

variable "external_ports_udp" {
  type    = "list"
  default = []
}

variable "external_ports_tcp" {
  type    = "list"
  default = []
}

variable "aws_keyname" {
  default = ""
}

variable "anzahlInstanzen" {
  default = 1
}