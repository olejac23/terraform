# Module for VM'er

## Beskrivelse
Oppretter en Linux-VM (Ubuntu 22.04 LTS) med nettverksgrensesnitt, valgfri offentlig IP og cloud-init (custom_data). Denne modulen brukes både for webserveren og for databaseserverne.

## Input Variables
| Navn                           | Type         | Beskrivelse                                                       |
|--------------------------------|--------------|-------------------------------------------------------------------|
| vm_name                        | string       | Navn på VM                                                        |
| resource_group_name            | string       | Navn på ressursgruppen                                            |
| location                       | string       | Azure-region                                                      |
| subnet_id                      | string       | ID til subnet                                                     |
| admin_username                 | string       | Admin-bruker for VM                                               |
| admin_password                 | string       | Admin-passord for VM (sensitive)                                  |
| create_public_ip               | bool         | Om VM-en skal ha offentlig IP (default: false)                    |
| custom_data                    | string       | Base64-kodet cloud-init script (cloud-init eller shell-script)    |
| backend_address_pool_id        | string       | (For DB-VM) ID til Load Balancer backend-pool for MySQL-trafikk   |
| db_host                        | string       | (For web-VM) Intern IP til database-loadbalancer                  |
| db_username                    | string       | (For web-VM) Brukernavn for database-tilkobling                   |
| db_password                    | string       | (For web-VM) Passord for database-tilkobling (sensitive)          |

## Outputs
| Navn       | Beskrivelse                           |
|------------|---------------------------------------|
| vm_id      | ID til den opprettede VM              |
| public_ip  | Offentlig IP (hvis `create_public_ip`)|


## 