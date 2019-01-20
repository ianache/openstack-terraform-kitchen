# openstack-terraform-kitchen
Provisioning OpenStack environment with terraform

## Install OpenStack (DevStack)
Install OpenStack (https://www.youtube.com/watch?v=r0ojujg3yC8)

sudo useradd -s /bin/bash -d /opt/stack -m stack
cat > /etc/sudoers.d/stack <<EOF
stack ALL=(ALL) NOPASSWD: ALL
EOF

sudo su -l stack
git clone https://git.openstack.org/openstack-dev/devstack
cd openstack

cat > local.config <<EOF
[[local|localrc]]
ADMIN_PASSWORD=secret
DATABASE_PASSWORD=\$ADMIN_PASSWORD
RABBIT_PASSWORD=\$ADMIN_PASSWORD
SERVICE_PASSWORD=\$ADMIN_PASSWORD
HOST_IP=<IP>
EOF
  
sed -i '1s/^/172.17.8.191    openstack\n/' /etc/hosts

./start.sh

## Environment Variables
export auth-url="http://172.17.8.191/identity
