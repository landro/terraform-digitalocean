# Configure the DigitalOcean Provider
# Will use content of DIGITALOCEAN_TOKEN env variable
provider "digitalocean" {
    
}

# Adjust number of servers to match your load
variable "number_of_servers" {
  default = "2"
}

# Create droplet based on distributed centos image
resource "digitalocean_droplet" "web" {
    count = "${var.number_of_servers}"
    image = "centos-7-0-x64"
    name = "web-server-${count.index}"
    region = "ams2"
    size = "512mb"
    ssh_keys = ["${digitalocean_ssh_key.ssh.id}"]   
}

# Create SSH key that can be connected 
# to droplets 
# 
# Generate SSH keys using
#
# ssh-keygen -b 4096 -t rsa  -f digital_ocean_key
#
resource "digitalocean_ssh_key" "ssh" {
    name = "Terraform Example"
    public_key = "${file("digital_ocean_key.pub")}"
}
