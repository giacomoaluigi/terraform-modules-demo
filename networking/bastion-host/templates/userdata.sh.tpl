MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="//"

--//
Content-Type: text/x-shellscript; charset="us-ascii"
#!/usr/bin/env bash

echo "${ssh_public_keys}" | tr "," "\n" >> /home/${username}/.ssh/authorized_keys


sudo -i apt update
sudo -i apt upgrade -y
sudo -i apt install -y postgresql-client redis-tools

--//--
