resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}


module "network" {
  source              = "./modules/network"
  vnet_name           = var.vnet_name
  address_space       = var.address_space
  web_subnet_name     = var.web_subnet_name
  web_subnet_prefix   = var.web_subnet_prefix
  db_subnet_name      = var.db_subnet_name
  db_subnet_prefix    = var.db_subnet_prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

module "loadbalancer_db" {
  source              = "./modules/loadbalancer"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.network.db_subnet_id
}

module "db_vm_1" {
  source              = "./modules/vm"
  vm_name             = var.db_vm_names[0]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.network.db_subnet_id
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  load_balancer_backend_address_pools_ids = [module.loadbalancer_db.backend_pool_id]
  backend_address_pool_id  = module.loadbalancer_db.backend_pool_id
  custom_data         = file("${path.module}/scripts/db-init.sh")
}

module "db_vm_2" {
  source              = "./modules/vm"
  vm_name             = var.db_vm_names[1]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.network.db_subnet_id
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  load_balancer_backend_address_pools_ids = [module.loadbalancer_db.backend_pool_id]
  backend_address_pool_id  = module.loadbalancer_db.backend_pool_id
  custom_data         = file("${path.module}/scripts/db-init.sh")
}

module "web_vm" {
  source              = "./modules/vm"
  vm_name             = var.web_vm_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.network.web_subnet_id
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  create_public_ip    = true
  custom_data         = templatefile("${path.module}/scripts/web-init.sh.tpl", { db_host = module.loadbalancer_db.lb_private_ip })
}
