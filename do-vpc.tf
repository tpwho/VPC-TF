variable "do_token" {}
variable "ssh_key" {}

provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_firewall" "backend" {
    name = "backend-fw"
    tags   = ["${digitalocean_tag.backend.id}"]

    inbound_rule = [
        {
            protocol           = "tcp"
            port_range         = "1-65535"
            source_addresses   = ["${digitalocean_droplet.backend.*.ipv4_address_private}", "${digitalocean_droplet.bastion.*.ipv4_address_private}"]
        },
        {
            protocol           = "udp"
            port_range         = "1-65535"
            source_addresses   = ["${digitalocean_droplet.backend.*.ipv4_address_private}", "${digitalocean_droplet.bastion.*.ipv4_address_private}"]
        },
        {
            protocol           = "icmp"
            source_addresses   = ["${digitalocean_droplet.backend.*.ipv4_address_private}", "${digitalocean_droplet.bastion.*.ipv4_address_private}"]
        },
    ]
    outbound_rule = [
        {
            protocol                = "tcp"
            port_range              = "1-65535"
            destination_addresses   = ["${digitalocean_droplet.backend.*.ipv4_address_private}", "${digitalocean_droplet.bastion.*.ipv4_address_private}"]
        },
        {
            protocol = "tcp"
            port_range = "80"
            destination_addresses = ["0.0.0.0/0", "::/0"]
        },
        {
            protocol = "tcp"
            port_range = "443"
            destination_addresses = ["0.0.0.0/0", "::/0"]
        },
        {
            protocol                = "udp"
            port_range              = "1-65535"
            destination_addresses   = ["${digitalocean_droplet.backend.*.ipv4_address_private}", "${digitalocean_droplet.bastion.*.ipv4_address_private}"]
        },
        {
            protocol = "udp"
            port_range = "53"
            destination_addresses = ["0.0.0.0/0", "::/0"]
        },
        {
            protocol                = "icmp"
            destination_addresses   = ["0.0.0.0/0", "::/0"]
        },
    ]
}

resource "digitalocean_firewall" "bastion" {
    name = "bastion-fw"
    tags   = ["${digitalocean_tag.bastion.id}"]

    inbound_rule = [
        {
            protocol           = "tcp"
            port_range         = "22"
            source_addresses    = ["0.0.0.0/0", "::/0"]
        },
        {
            protocol           = "tcp"
            port_range         = "1-65535"
            source_addresses   = ["${digitalocean_droplet.backend.*.ipv4_address_private}", "${digitalocean_droplet.bastion.*.ipv4_address_private}"]
        },
        {
            protocol           = "udp"
            port_range         = "1-65535"
            source_addresses   = ["${digitalocean_droplet.backend.*.ipv4_address_private}", "${digitalocean_droplet.bastion.*.ipv4_address_private}"]
        },
        {
            protocol           = "icmp"
            source_addresses   = ["0.0.0.0/0","::/0"]
        },
    ]
    outbound_rule = [
        {
            protocol                = "tcp"
            port_range              = "1-65535"
            destination_addresses   = ["${digitalocean_droplet.backend.*.ipv4_address_private}", "${digitalocean_droplet.bastion.*.ipv4_address_private}"]
        },
        {
            protocol = "tcp"
            port_range = "22"
            destination_addresses = ["0.0.0.0/0", "::/0"]
        },
        {
            protocol = "tcp"
            port_range = "80"
            destination_addresses = ["0.0.0.0/0", "::/0"]
        },
        {
            protocol = "tcp"
            port_range = "443"
            destination_addresses = ["0.0.0.0/0", "::/0"]
        },
        {
            protocol                = "udp"
            port_range              = "1-65535"
            destination_addresses   = ["${digitalocean_droplet.backend.*.ipv4_address_private}", "${digitalocean_droplet.bastion.*.ipv4_address_private}"]
        },
        {
            protocol = "udp"
            port_range = "53"
            destination_addresses = ["0.0.0.0/0", "::/0"]
        },
        {
            protocol           = "icmp"
            destination_addresses   = ["0.0.0.0/0","::/0"]
        },
    ]
}
resource "digitalocean_droplet" "backend" {
    name   = "tf-backend-${format("%02d", count.index+1)}"
    size   = "512mb"
    image  = "ubuntu-16-04-x64"
    region = "nyc3"
    count  = 2
    tags   = ["${digitalocean_tag.backend.id}"]
    private_networking = true
    ssh_keys = ["${digitalocean_ssh_key.default.id}"]
}

resource "digitalocean_droplet" "bastion" {
    name   = "tf-bastion-${format("%02d", count.index+1)}"
    size   = "512mb"
    image  = "ubuntu-16-04-x64"
    region = "nyc3"
    count  = 1
    tags   = ["${digitalocean_tag.bastion.id}"]
    private_networking = true
    ssh_keys = ["${digitalocean_ssh_key.default.id}"]
}

resource "digitalocean_tag" "backend" {
    name = "backend"
}

resource "digitalocean_tag" "bastion" {
    name = "bastion"
}

resource "digitalocean_ssh_key" "default" {
    name = "Default Key"
    public_key = "${file("${var.ssh_key}")}"
}
