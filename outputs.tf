output "tf-backend-0-private-ip" {
    value = "${digitalocean_droplet.backend.0.ipv4_address_private}"
}
output "tf-backend-1-private-ip" {
    value = "${digitalocean_droplet.backend.1.ipv4_address_private}"
}
output "tf-bastion-0-private-ip" {
    value = "${digitalocean_droplet.bastion.0.ipv4_address_private}"
}
output "tf-bastion-0-public-ip" {
    value = "${digitalocean_droplet.bastion.0.ipv4_address_public}"
}
output "hostname" {
    value = "${digitalocean_droplet.bastion.0.name}"
}