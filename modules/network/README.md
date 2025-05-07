# Module for network

## Beskrivelse
Oppretter et virtuelt nettverk, to subnets (web, database) og tilhørende Network Security Groups.

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

