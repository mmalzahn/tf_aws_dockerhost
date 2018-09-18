$cmd='ssh -L 127.0.0.1:${random_port}:${host_fqdn}:22 -i .\keys\${workspace}\${userid}.key.pem -l ${userid} -C -T -N -v -4 -o "StrictHostKeyChecking=false" ${bastionhost_fqdn}'

Invoke-Expression -Command "cmd /c start cmd /c $cmd"
Start-Sleep -Seconds 3

$cmd2 = 'ssh -i .\keys\${workspace}\${userid}.key.pem -l ec2-user -p ${random_port} -4 -o "StrictHostKeyChecking=false" 127.0.0.1'
Invoke-Expression -Command "cmd /c start cmd /c $cmd2"