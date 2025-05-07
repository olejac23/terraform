# Terraform Azure Infrastruktur

## Beskrivelse
Dette prosjektet oppretter:
- En web-VM (Ubuntu 22.04 LTS) med en Flask-app som viser en melding fra MySQL.
- To database-VM-er (Ubuntu 22.04 LTS) med MySQL, lastbalansert via en intern Azure Load Balancer.
- Se også README-filer innenfor hver enkelt modul for mer utfyllende informasjon.

## Struktur
- `modules/network`: VNet, subnets og NSG
- `modules/loadbalancer`: Intern MySQL-load balancer
- `modules/vm`: Generisk VM-modul med cloud-init

## Hvordan laste ned prosjektet og teste det selv

### Forutsetninger
- Terraform
- Azure CLI
- Enheten din støtter Git. Se denne guiden på hvordan du installerer Git på din egen maskin: https://github.com/git-guides/install-git

### Deploy
```bash
git clone https://github.com/olejac23/terraform
cd Arbeidskrav-terraform
az login --use-device-code   FØLG INSTRUKSENE SOM DUKKER OPP PÅ SKJERMEN.
terraform init
terraform plan
terraform apply
```

### Test
1. Finn `web_vm_public_ip` i outputs.
2. Åpne `http://<web_vm_public_ip>/` i nettleseren. Merk at det ikke vil fungere å nå webserveren på http da det er en feil i prosjektet som jeg ikke klarte å rette opp i.
3. Dersom du ønsker å koble deg til webserveren via SSH er du nødt til å legge opp dette selv i NSG for Web-serveren. Dette er ikke lagt til av sikkerhetsgrunner.
