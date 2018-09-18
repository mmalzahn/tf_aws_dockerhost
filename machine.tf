resource "aws_instance" "testmachine" {
  count                       = "${var.anzahlInstanzen}"
  ami                         = "${data.aws_ami.dockerhostPackerAmi.id}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${var.external ? element(data.terraform_remote_state.baseInfra.subnet_ids_dmz, count.index):element(data.terraform_remote_state.baseInfra.subnet_ids_backend, count.index)}"
  key_name                    = "${random_string.dnshostname.result}"
  associate_public_ip_address = "${var.external}"
  volume_tags                 = "${local.common_tags}"
  user_data                   = "${data.template_file.installscript.rendered}"

  vpc_security_group_ids = [
    "${aws_security_group.SG_Docker_IN_intern.*.id}",
    "${aws_security_group.SG_SSH_IN_extern.*.id}",
    "${aws_security_group.SG_SSH_IN_intern.*.id}",
    "${aws_security_group.SG_CustomTCP_IN_anywhere.*.id}",
    "${aws_security_group.SG_CustomUDP_IN_anywhere.*.id}",
  ]

  lifecycle {
    ignore_changes = [
      "tags.tf_created",
      "volume_tags.tf_created",
    ]
  }

  tags = "${merge(local.common_tags,
            map(
              "Name","${local.resource_prefix}Dockerhost"
              )
              )}"
}

resource "aws_route53_record" "testmachine" {
  count           = "${var.anzahlInstanzen}"
  allow_overwrite = "true"
  depends_on      = ["aws_instance.testmachine"]
  name            = "${random_string.dnshostname.result}-${count.index}"
  ttl             = "60"
  type            = "A"
  records         = ["${var.external ? element(aws_instance.testmachine.*.public_ip,count.index) : element(aws_instance.testmachine.*.private_ip,count.index)}"]
  zone_id         = "${data.terraform_remote_state.baseInfra.dns_zone_id}"
}