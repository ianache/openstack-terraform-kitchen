# variables
variable "region" {
  default = "RegionOne"
}

variable "os_user" { default = "admin"  }
variable "os_pwd" { }
variable "os_tenant" { default = "admin" }
variable "network_cidr" {}

# Configure the OpenStack Provider
provider "openstack" {
   user_name = "${var.os_user}"
   password = "${var.os_pwd}"
   region = "${var.region}"
   auth_url = "http://172.17.8.191/identity"
   tenant_name = "${var.os_tenant}"
}

##
## KeyPair
##
resource "openstack_compute_keypair_v2" "fuseesb" {
  name = "fusesb-keypair"
}


##
## VOLUME
##
resource "openstack_blockstorage_volume_v2" "fuseesb01_myvol" {
  name = "fuseesb01_myvol"
  size = 1
  description = "Volumen del servidor FuseESB"
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
  cidr       = "${var.network_cidr}"
  ip_version = 4
}

##
## COMPUTE: Create a FuseESB Instance
##
resource "openstack_compute_instance_v2" "fuseesb01" {
  name      = "fuseesb01"
  key_pair = "fusesb-keypair"
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
