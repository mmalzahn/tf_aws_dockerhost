resource "aws_lb" "dh_intern" {
  name               = "${local.resource_prefix_short}intern"
  internal           = "false"
  load_balancer_type = "network"
  subnets            = ["${data.terraform_remote_state.baseInfra.subnet_ids_dmz}"]

  lifecycle {
    ignore_changes = ["tags.tf_created"]
  }

  tags = "${local.common_tags}"
}

resource "aws_lb" "dh_extern" {
  name               = "${local.resource_prefix_short}extern"
  internal           = "false"
  load_balancer_type = "network"
  subnets            = ["${data.terraform_remote_state.baseInfra.subnet_ids_dmz}"]

  lifecycle {
    ignore_changes = ["tags.tf_created"]
  }

  tags = "${local.common_tags}"
}

resource "aws_lb_listener" "extern_https_in" {
  load_balancer_arn = "${aws_lb.dh_extern.arn}"
  port              = 443
  protocol          = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.interner_dockercluster_444.arn}"
    type             = "forward"
  }
}

resource "aws_lb_listener" "extern_http_in" {
  load_balancer_arn = "${aws_lb.dh_extern.arn}"
  port              = 80
  protocol          = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.interner_dockercluster_81.arn}"
    type             = "forward"
  }
}

resource "aws_lb_listener" "intern_https_in" {
  load_balancer_arn = "${aws_lb.dh_intern.arn}"
  port              = 443
  protocol          = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.interner_dockercluster_445.arn}"
    type             = "forward"
  }
}

resource "aws_lb_listener" "intern_http_in" {
  load_balancer_arn = "${aws_lb.dh_intern.arn}"
  port              = 80
  protocol          = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.interner_dockercluster_82.arn}"
    type             = "forward"
  }
}

resource "aws_lb_target_group" "interner_dockercluster_444" {
  name              = "${local.resource_prefix_short}tcp444"
  port              = 444
  protocol          = "TCP"
  vpc_id            = "${data.terraform_remote_state.baseInfra.vpc_id}"
  proxy_protocol_v2 = true

  lifecycle {
    ignore_changes = ["tags.tf_created"]
  }

  tags = "${local.common_tags}"
}

resource "aws_lb_target_group" "interner_dockercluster_445" {
  name              = "${local.resource_prefix_short}tcp445"
  port              = 445
  protocol          = "TCP"
  vpc_id            = "${data.terraform_remote_state.baseInfra.vpc_id}"
  proxy_protocol_v2 = true

  lifecycle {
    ignore_changes = ["tags.tf_created"]
  }

  tags = "${local.common_tags}"
}

resource "aws_lb_target_group" "interner_dockercluster_81" {
  name              = "${local.resource_prefix_short}tcp81"
  port              = 81
  protocol          = "TCP"
  vpc_id            = "${data.terraform_remote_state.baseInfra.vpc_id}"
  proxy_protocol_v2 = true

  lifecycle {
    ignore_changes = ["tags.tf_created"]
  }

  tags = "${local.common_tags}"
}

resource "aws_lb_target_group" "interner_dockercluster_82" {
  name              = "${local.resource_prefix_short}tcp82"
  port              = 82
  protocol          = "TCP"
  vpc_id            = "${data.terraform_remote_state.baseInfra.vpc_id}"
  proxy_protocol_v2 = true

  lifecycle {
    ignore_changes = ["tags.tf_created"]
  }

  tags = "${local.common_tags}"
}

resource "aws_route53_record" "wc_dns_intern" {
  allow_overwrite = "true"
  depends_on      = ["aws_lb.dh_intern"]

  name    = "*.intern"
  ttl     = 60
  type    = "CNAME"
  records = ["${aws_lb.dh_intern.dns_name}"]
  zone_id = "${data.terraform_remote_state.baseInfra.dns_zone_id}"
}
resource "aws_route53_record" "wc_dns_extern" {
  allow_overwrite = "true"
  depends_on      = ["aws_lb.dh_extern"]

  name    = "*.extern"
  ttl     = 60
  type    = "CNAME"
  records = ["${aws_lb.dh_extern.dns_name}"]
  zone_id = "${data.terraform_remote_state.baseInfra.dns_zone_id}"
}

resource "aws_lb_target_group_attachment" "interner_dockercluster_81" {
  target_group_arn = "${aws_lb_target_group.interner_dockercluster_81.arn}"
  target_id ="${aws_instance.testmachine.id}"
  port = 81
}
resource "aws_lb_target_group_attachment" "interner_dockercluster_82" {
  target_group_arn = "${aws_lb_target_group.interner_dockercluster_82.arn}"
  target_id ="${aws_instance.testmachine.id}"
  port = 82
}
resource "aws_lb_target_group_attachment" "interner_dockercluster_444" {
  target_group_arn = "${aws_lb_target_group.interner_dockercluster_444.arn}"
  target_id ="${aws_instance.testmachine.id}"
  port = 444
}
resource "aws_lb_target_group_attachment" "interner_dockercluster_445" {
  target_group_arn = "${aws_lb_target_group.interner_dockercluster_445.arn}"
  target_id ="${aws_instance.testmachine.id}"
  port = 445
}
