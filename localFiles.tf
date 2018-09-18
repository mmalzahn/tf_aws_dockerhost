resource "local_file" "connectSshScript" {
  count    = "${var.anzahlInstanzen}"
  content  = "${element(data.template_file.startSshScript.*.rendered,count.index)}"
  filename = "${path.module}/start_ssh-${count.index}_connection.ps1"
}
resource "local_file" "connectDockerSocket" {
  content  = "${data.template_file.connectDockerSocket.rendered}"
  filename = "${path.module}/SetInternDockerconnection.ps1"
}
