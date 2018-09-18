output "bastion_dns" {
  value = "${data.terraform_remote_state.baseInfra.bastion_dns}"
}

output "bastion_ip" {
  value = "${data.terraform_remote_state.baseInfra.*.bastion_public_ip}"
}

output "Machine_Dns" {
  value = "${aws_route53_record.testmachine.*.fqdn}"
}