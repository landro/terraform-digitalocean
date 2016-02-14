# Configure the Google provider
# Will use credantials in account.json file 
provider "google" {
  credentials = "${file("../account.json")}"
  project     = "terraform-example"
  region      = "europe-west1"
}

# Create a managed zone
resource "google_dns_managed_zone" "production" {
    name = "production-zone"
    # Change this!
    dns_name = "landro.info."
    description = "Used for Terraform example"
}

# Google uses four NS servers
# Names do vary!
# Register NS servers with domain name registrar 

output "ns1" {
    value = "${google_dns_managed_zone.production.name_servers.0}"
}

output "ns2" {
    value = "${google_dns_managed_zone.production.name_servers.1}"
}

output "ns3" {
    value = "${google_dns_managed_zone.production.name_servers.2}"
}

output "ns4" {
    value = "${google_dns_managed_zone.production.name_servers.3}"
}
