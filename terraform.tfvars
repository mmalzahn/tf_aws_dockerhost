##           vCPU   Mem
## t2.nano     1    0.5
## t2.micro    1     1
## t2.small    1     2
## t2.medium   2     4
## t2.large    2     8

instance_type = "t2.medium"

anzahlInstanzen = 1

tag_responsibel = "Dodo Mustermann"

project_name = "MusterProject1"

remote_state_bucket = "tf-state-bodyxsddzhllgkrg"

# remote_state_key = "baseinfrastruktur.state"

external = true

external_ports_tcp = ["80", "443", "444","445","81","82"]

#external_ports_udp = ["53"]

remote_state_bucket_region = "eu-west-1"

aws_region = "eu-west-1"
uni_id = "jkfahskdjf"
