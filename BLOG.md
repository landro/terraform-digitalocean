# Kolonisér skyen!

For noen måneder tilbake, skrev Trond Arve Wasskog om [noen av fordelene med nettsky-teknologi](https://open.bekk.no/maskinvare-blir-mjukvare). Han nevner blant annet at man i dag kan definere miljøer i software, og at man kan etablere disse i løpet av sekunder, men han sier lite om hvordan.
Og - guess what - denne posten handler nettopp om det! - om hvordan man ved hjelp av et verktøy som heter [Terraform](https://www.terraform.io), kan definere og etablere komplette miljøer på meget kort tid.

## Terraform

Terraform, som for øvrig finnes både til OS X, Linux og Windows, er et fantastisk lite verktøy som lar deg definere infrastrukturen din på en lettlest måte i JSON-lignende konfigurasjonsfiler. Og med infrastruktur mener jeg bl.a. virtuelle servere, nettverks- og firewall- oppsett, lastbalanseringsoppsett, mail, DNS og alt mulig annet som er mulig hos de ulike sky-leverandørene. Og det som er unikt med Terraform, er at det lar deg definere infrastrukturer, eller miljøer som også mange kaller det, på tvers av ulike leverandører og plattformer!

## Demo time!

For anledningen tenkte jeg å sette opp en enkel infrastruktur bestående av et par linux servere med Apache Httpd installert kjørende i nettskyen til Digital Ocean i Amsterdam, samt DNS i Google Cloud. 

Ved hjelp av en tekst editor, lager jeg altså en fil som heter terraform.tf (den kan hete hva som helst så lenge den ender på .tf). Det første jeg må gjøre er å legge inn Digital Ocean provideren, siden jeg skal bruke dem:

    provider "digitalocean" {
        
    }

Det neste er å legge inn at jeg trenger en virtuell maskin, eller droplet, som Digital Ocean kaller det:

    resource "digitalocean_droplet" "web" {
        image = "centos-7-0-x64"
        name = "web-server-0"
        region = "ams2"
        size = "512mb"       
    }

inkrementell
