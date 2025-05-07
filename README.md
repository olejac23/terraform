# Terraform Azure Infrastruktur

## Beskrivelse
Dette prosjektet oppretter:
- En web-VM (Ubuntu 22.04 LTS) med en Flask-app som viser en melding fra MySQL.
- To database-VM-er (Ubuntu 22.04 LTS) med MySQL, lastbalansert via en intern Azure Load Balancer.

## Struktur
- `modules/network`: VNet, subnets og NSG
- `modules/loadbalancer`: Intern MySQL-load balancer
- `modules/vm`: Generisk VM-modul med cloud-init

## Oppsett

### Forutsetninger
- Terraform
- Azure CLI

### Deploy
```bash
git clone <repo-url>
cd terraform-project
az login
terraform init
terraform plan
terraform apply
```

### Test
1. Finn `web_vm_public_ip` i utdata.
2. Åpne `http://<web_vm_public_ip>/` i nettleseren.
