# Configure the DigitalOcean Provider
# Will use content of DIGITALOCEAN_TOKEN env variable
provider "digitalocean" {
    
}

# Customise domain name to your needs
variable "domain_name" {
  default = "terraform.landro.info"
}

# Create SSH key that can be connected 
# to droplets (se README.md for details on how
# to generate SSH key pair)
resource "digitalocean_ssh_key" "ssh" {
    name = "Terraform Example"
    public_key = "${file("digital_ocean_key.pub")}"
}

# Create droplet based on distributed centos image
resource "digitalocean_droplet" "web" {
    image = "centos-7-0-x64"
    name = "web-server"
    region = "ams2"
    size = "512mb"
    backups = "false"
    ipv6 = "false"
    ssh_keys = ["${digitalocean_ssh_key.ssh.id}"]
}

# Create DNS record for floating IP
resource "digitalocean_domain" "default" {
    name = "${var.domain_name}"
    ip_address = "${digitalocean_floating_ip.web.ip_address}"
}

# Create floating ip and connect it to droplet
resource "digitalocean_floating_ip" "web" {
    droplet_id = "${digitalocean_droplet.web.id}"
    region = "${digitalocean_droplet.web.region}"
}

# Output non-floating ip for droplet
output "ip" {
    value = "${digitalocean_droplet.web.ipv4_address}"
}
# Output floating ip
output "floatingip" {
    value = "${digitalocean_floating_ip.web.ip_address}"
}
