# Terraform project demonstrating the DigitalOcean provider

## Generate an SSH keypair using ssh-keygen

    ssh-keygen -b 4096 -t rsa  -f digital_ocean_key

## Verify DNS record with DigitalOcean name server

    dig @ns1.digitalocean.com terraform.landro.info

## SSH into droplet 

    ssh -i digital_ocean_key root@terraform.landro.info
