output "web_vm_public_ip" {
  description = "Public IP of the web VM"
  value       = module.web_vm.public_ip
}

output "db_lb_private_ip" {
  description = "Private IP of the database load balancer"
  value       = module.loadbalancer_db.lb_private_ip
}
