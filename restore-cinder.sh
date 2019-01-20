losetup -f
sudo losetup /dev/loop0 /opt/stack/data/stack-volumes-default-backing-file
losetup -f
sudo losetup /dev/loop1 /opt/stack/data/stack-volumes-lvmdriver-1-backing-file
sudo systemctl restart devstack@c-vol.service
