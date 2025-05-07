# Module for Load Balancer

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