# Configure the OpenStack Provider
provider "openstack" {
   user_name = "admin"
   password = "secret"
   region = "RegionOne"
   auth_url = "http://172.17.8.191/identity"
   tenant_name = "admin"
}

##
## VOLUME
##
resource "openstack_blockstorage_volume_v2" "fuseesb01_myvol" {
  name = "fuseesb01_myvol"
  size = 2
  description = "Volumen del servidor FuseESB"
  region = "RegionOne"
  count = 1
}

##
## NETWORK
##
resource "openstack_networking_network_v2" "prod_fuse_network" {
  name           = "prod_fuse_network"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "prod_fuse_subnet_1" {
  name       = "subnet_1"
  network_id = "${openstack_networking_network_v2.prod_fuse_network.id}"
  cidr       = "10.0.2.0/24"
  ip_version = 4
}

##
## COMPUTE: Create a FuseESB Instance
##
resource "openstack_compute_instance_v2" "fuseesb01" {
  name      = "fuseesb01"
#  region = "nova"
  flavor_name = "m1.tiny" 
  image_id = "3bc4a056-e530-487a-a04e-1f50fbb12f97"

  network {
     uuid = "${openstack_networking_network_v2.prod_fuse_network.id}"
#    name = "prod_fuse_network"
  } 
}

resource "openstack_compute_volume_attach_v2" "attached" {
  instance_id = "${openstack_compute_instance_v2.fuseesb01.id}"
  volume_id = "${openstack_blockstorage_volume_v2.fuseesb01_myvol.id}"
}
