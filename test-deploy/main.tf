terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
  }
}

variable "name" {
  default = "aptly-testing"
}

resource "openstack_compute_keypair_v2" "keypair" {
  name       = var.name
  public_key = file(pathexpand("~/.ssh/id_ed25519.pub"))
}

resource "openstack_networking_floatingip_v2" "fip" {
  pool = "ext01"
}

resource "openstack_networking_secgroup_v2" "secgroup" {
  name = var.name
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 1
  port_range_max    = 65535
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup.id
}

resource "openstack_compute_instance_v2" "instance" {
  name            = var.name
  image_name      = "Ubuntu 22.04"
  flavor_name     = "SCS-8V:32:100"
  key_pair        = openstack_compute_keypair_v2.keypair.name
  security_groups = [openstack_networking_secgroup_v2.secgroup.name]
  user_data       = file("cloud-init.yml")

  network {
    name = "p500924-beermann-network"
  }
}

resource "openstack_compute_floatingip_associate_v2" "fip" {
  floating_ip = openstack_networking_floatingip_v2.fip.address
  instance_id = openstack_compute_instance_v2.instance.id
}

output "public_ip" {
  value = openstack_compute_floatingip_associate_v2.fip.floating_ip
}
