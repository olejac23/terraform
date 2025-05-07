variable "vm_name" {}
variable "resource_group_name" {}
variable "location" {}
variable "subnet_id" {}
variable "admin_username" {}
variable "admin_password" {}
variable "create_public_ip" {
  type    = bool
  default = false
}
variable "custom_data" {
  type = string
}
variable "load_balancer_backend_address_pools_ids" {
  description = "Liste med Load Balancer backend-pool IDer som NIC skal knyttes til"
  type        = list(string)
  default     = []
}

variable "backend_address_pool_id" {
  description = "ID på Load Balancer backend address pool for denne VM-en"
  type        = string
  default     = ""
}