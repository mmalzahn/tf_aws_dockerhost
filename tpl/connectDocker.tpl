$cmd='ssh -L 127.0.0.1:${random_port}:${host_fqdn}:2375 -i .\keys\${workspace}\${userid}.key.pem -l ${userid} -C -T -N -v -4 -o "StrictHostKeyChecking=false" ${bastionhost_fqdn}'
Invoke-Expression -Command "cmd /c start cmd /c $cmd"

$Env:DOCKER_HOST = "tcp://127.0.0.1:${random_port}"
$Env:COMPOSE_CONVERT_WINDOWS_PATHS = "true"
