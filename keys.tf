resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "local_file" "privateKeyFile" {
  content  = "${tls_private_key.private_key.private_key_pem}"
  filename = "${path.module}/keys/${terraform.workspace}/${random_string.dnshostname.result}.key.pem"
}

resource "local_file" "publicKeyFile" {
  content  = "${tls_private_key.private_key.public_key_pem}"
  filename = "${path.module}/keys/${terraform.workspace}/${random_string.dnshostname.result}.pem"
}

resource "local_file" "publicKeyFileOpenSsh" {
  content  = "${tls_private_key.private_key.public_key_openssh}"
  filename = "${path.module}/keys/${terraform.workspace}/${random_string.dnshostname.result}_openssh.pub"
}
resource "aws_s3_bucket_object" "uploadPubkey" {
  bucket = "${data.terraform_remote_state.baseInfra.s3PubKeyBucket_name}"
  content = "${tls_private_key.private_key.public_key_openssh}"
  key    = "keys/${random_string.dnshostname.result}.pub"

  lifecycle {
    ignore_changes = ["tags"]
  }

  tags = "${local.common_tags}"
}
resource "aws_key_pair" "keypair" {
  key_name   = "${random_string.dnshostname.result}"
  public_key = "${tls_private_key.private_key.public_key_openssh}"
  depends_on = ["tls_private_key.private_key"]
}
