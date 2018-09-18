resource "local_file" "connectSshScript" {
  content  = "${data.template_file.startSshScript.rendered}"
  filename = "${path.module}/start_ssh_connection.ps1"
}
resource "local_file" "connectDockerSocket" {
  content  = "${data.template_file.connectDockerSocket.rendered}"
  filename = "${path.module}/SetInternDockerconnection.ps1"
}
