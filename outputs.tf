output "bastion_dns" {
  value = "${data.terraform_remote_state.baseInfra.bastion_dns}"
}

output "bastion_ip" {
  value = "${data.terraform_remote_state.baseInfra.*.bastion_public_ip}"
}

output "Machine_Dns_extern" {
  value = "${aws_route53_record.testmachine_extern.fqdn}"
}
output "Machine_Dns_intern" {
  value = "${aws_route53_record.testmachine_intern.fqdn}"
}