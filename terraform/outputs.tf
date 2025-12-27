output "app_vm_public_ip" {
  value = yandex_compute_instance.app-vm.network_interface.0.nat_ip_address
}


#output "static_ip_address" {
#  value = yandex_vpc_address.app-address.external_ipv4_address[0].address
#}
output "cloud_init_status" {
  value = "Cloud-init script located at ${path.module}/cloud-init.yml"
  description = "Path to cloud-init configuration file"
}
output "mysql_host" {
  value       = module.mysql_cluster.host_fqdn
  description = "MySQL host FQDN"
}

output "mysql_database" {
  value       = module.mysql_cluster.database_name
  description = "MySQL database name"
}

output "mysql_username" {
  value       = module.mysql_cluster.username
  description = "MySQL username"
}

output "mysql_connection_string" {
  value       = "mysql://${module.mysql_cluster.username}:${var.mysql_password}@${module.mysql_cluster.host_fqdn}:3306/${module.mysql_cluster.database_name}"
  sensitive   = true
  description = "MySQL connection string"
}
