# Terraform project demonstrating the DigitalOcean and Google Cloud providers


## DNS

First run 

    terraform apply
    
in the dns folder, in order to create a DNS managed zone with Google

## NS servers

Configure the NS settings with your registrar. This might take some time to propagate!

## Generate an SSH keypair using ssh-keygen

    ssh-keygen -b 4096 -t rsa  -f digital_ocean_key

## Servers

Create a couple droplets with DigitalOcean, and create DNS entries for them running 

    terraform apply
    
in the root directory.

## Verify DNS record with Google Cloud name server

    dig @ns-cloud-<XX>.googledomains.com terraform.landro.info

## SSH into droplet 

    ssh -i digital_ocean_key root@ssh0.terraform.landro.info
    ssh -i digital_ocean_key root@ssh1.terraform.landro.info
    ...
    
## View website in browser

[http://terraform.landro.info](http://terraform.landro.info)