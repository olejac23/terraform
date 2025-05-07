# Network Module

## Beskrivelse
Oppretter en Virtual Network, to subnets (web, database) og tilhørende Network Security Groups.

## Input Variables
| Navn               | Type         | Beskrivelse                               |
|--------------------|--------------|-------------------------------------------|
| vnet_name          | string       | Navn på Virtual Network                   |
| address_space      | list(string) | Adresseområde for VNet                    |
| web_subnet_name    | string       | Navn på web-subnet                        |
| web_subnet_prefix  | list(string) | Prefix for web-subnet                     |
| db_subnet_name     | string       | Navn på database-subnet                   |
| db_subnet_prefix   | list(string) | Prefix for database-subnet                |
| location           | string       | Azure-region                              |
| resource_group_name| string       | Navn på ressursgruppen                    |

## Outputs
| Navn            | Beskrivelse                       |
|-----------------|-----------------------------------|
| web_subnet_id   | ID til web-subnet                 |
| db_subnet_id    | ID til database-subnet            |

## Usage
```hcl
module "network" {
  source              = "../modules/network"
  vnet_name           = "my-vnet"
  address_space       = ["10.0.0.0/16"]
  web_subnet_name     = "web-subnet"
  web_subnet_prefix   = ["10.0.1.0/24"]
  db_subnet_name      = "db-subnet"
  db_subnet_prefix    = ["10.0.2.0/24"]
  location            = "westeurope"
  resource_group_name = "my-rg"
}

---

## modules/vm/README.md
```markdown
# VM Module

## Beskrivelse
Oppretter en Linux-VM (Ubuntu 22.04 LTS) med nettverksgrensesnitt, valgfri offentlig IP og cloud-init (custom_data).

## Input Variables
| Navn                           | Type         | Beskrivelse                                            |
|--------------------------------|--------------|--------------------------------------------------------|
| vm_name                        | string       | Navn på VM                                             |
| resource_group_name            | string       | Navn på ressursgruppen                                 |
| location                       | string       | Azure-region                                           |
| subnet_id                      | string       | ID til subnet                                          |
| admin_username                 | string       | Admin-bruker for VM                                    |
| admin_password                 | string       | Admin-passord for VM (sensitive)                       |
| create_public_ip               | bool         | Om VM-en skal ha offentlig IP (default: false)        |
| custom_data                    | string       | Base64-kodet cloud-init script                         |
| backend_address_pool_id        | string       | (Optional) ID til Load Balancer backend-pool for DB-VM  |
| db_host                        | string       | (For web-VM) Intern IP til database-loadbalancer       |
| db_username                    | string       | (For web-VM) Brukernavn for database-tilkobling        |
| db_password                    | string       | (For web-VM) Passord for database-tilkobling (sens)    |

## Outputs
| Navn       | Beskrivelse                           |
|------------|---------------------------------------|
| vm_id      | ID til den opprettede VM              |
| public_ip  | Offentlig IP (hvis `create_public_ip`)|

## Usage
```hcl
module "WebServer" {
  source                  = "../modules/vm"
  vm_name                 = "web-vm"
  resource_group_name     = "my-rg"
  location                = "westeurope"
  subnet_id               = module.network.web_subnet_id
  admin_username          = "azureuser"
  admin_password          = "P@ssword1234!"
  create_public_ip        = true
  db_host                 = module.loadbalancer_db.lb_private_ip
  db_username             = var.db_username
  db_password             = var.db_password
  custom_data             = base64encode(templatefile(
                               "../scripts/web-init.sh.tpl",
                               { db_host = module.loadbalancer_db.lb_private_ip,
                                 db_username = var.db_username,
                                 db_password = var.db_password }
                             ))
}



---

## modules/loadbalancer/README.md
```markdown
# Load Balancer Module

## Beskrivelse
Oppretter en intern Azure Load Balancer med frontend-IP i angitt subnet, backend-pool, helsesjekk (probe) og regel for MySQL-trafikk.

## Input Variables
| Navn                | Type         | Beskrivelse                             |
|---------------------|--------------|-----------------------------------------|
| location            | string       | Azure-region                            |
| resource_group_name | string       | Navn på ressursgruppen                  |
| subnet_id           | string       | ID til subnet der frontend-IP skal ligge|

## Outputs
| Navn            | Beskrivelse                             |
|-----------------|-----------------------------------------|
| lb_private_ip   | Intern IP til Load Balancer frontend    |
| backend_pool_id | ID til backend address pool             |

## Usage
```hcl
module "DBLoadBalancer" {
  source              = "../modules/loadbalancer"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = module.network.db_subnet_id
}

# Deretter sender du output videre til VM-modulene:
# backend_address_pool_id = module.DBLoadBalancer.backend_pool_id