# Configure the DigitalOcean Provider
# Will use content of DIGITALOCEAN_TOKEN env variable
provider "digitalocean" {
    
}

# Configure the Google provider
# Will use credantials in account.json file 
provider "google" {
  credentials = "${file("account.json")}"
  project     = "terraform-example"
  region      = "europe-west1"
}

# Customise this
variable "domain_name" {
  default = "terraform.landro.info"
}

# Adjust number of servers to match your load
variable "number_of_servers" {
  default = "2"
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
    count = "${var.number_of_servers}"
    image = "centos-7-0-x64"
    name = "web-server-${count.index}"
    region = "ams2"
    size = "512mb"
    backups = "false"
    ipv6 = "false"
    ssh_keys = ["${digitalocean_ssh_key.ssh.id}"]
    
    # Install and run Apache httpd after 
    # booting droplet
    provisioner "remote-exec" {
        inline = [
        	"yum -y install httpd",
        	"systemctl start httpd"
        ]
    }
    
    connection {
    	type = "ssh"
        user = "root"
        private_key = "${file("digital_ocean_key")}"
    }
    
}

# Create floating IPs and connect to droplets
resource "digitalocean_floating_ip" "web" {
    count = "${var.number_of_servers}"
    droplet_id = "${element(digitalocean_droplet.web.*.id, count.index)}"
    region = "${element(digitalocean_droplet.web.*.region, count.index)}"
}

# Create DNS records using floating IP
resource "google_dns_record_set" "www" {
    managed_zone = "production-zone"
    # Change this!
    name = "${var.domain_name}."
    type = "A"
    ttl = 300
    rrdatas = ["${digitalocean_floating_ip.web.*.ip_address}"]
}

# Create DNS records in order to manage servers
resource "google_dns_record_set" "ssh" {
    count = "${var.number_of_servers}"
    managed_zone = "production-zone"
    # Change this!
    name = "ssh${count.index}.${var.domain_name}."
    type = "A"
    ttl = 300
    rrdatas = ["${element(digitalocean_droplet.web.*.ipv4_address, count.index)}"]
}