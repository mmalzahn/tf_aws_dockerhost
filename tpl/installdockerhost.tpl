#cloud-config
repo_update: false

runcmd:
- mkdir /tmpmount
- mount -t efs ${file_system_id}:/ /tmpmount
- mkdir /tmpmount/${project_id}
- umount /tmpmount
- rmdir /tmpmount
- mkdir -p ${efs_directory}
- echo "${file_system_id}:/${project_id}/ ${efs_directory} efs tls,_netdev" >> /etc/fstab
- mount -a -t efs defaults
- docker swarm init
- rm /efs/swarmtoken.txt
- docker swarm join-token -q worker >>/efs/swarm_worker.token
- docker swarm join-token -q manager >>/efs/swarm_manager.token