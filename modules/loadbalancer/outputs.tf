output "lb_private_ip" {
  value = azurerm_lb.lb.frontend_ip_configuration[0].private_ip_address
}

output "backend_pool_id" {
  value = azurerm_lb_backend_address_pool.pool.id
}