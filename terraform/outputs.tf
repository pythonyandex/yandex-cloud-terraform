output "app_vm_public_ip" {
  value = yandex_compute_instance.app-vm.network_interface.0.nat_ip_address
}

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

output "mysql_subnet_id" {
  value       = module.mysql_cluster.host_subnet_id
  description = "Subnet ID MySQL хоста"
}

output "mysql_connection_string" {
  value       = "mysql://${module.mysql_cluster.username}:${var.mysql_password}@${module.mysql_cluster.host_fqdn}:3306/${module.mysql_cluster.database_name}"
  sensitive   = true
  description = "MySQL connection string"
}

output "mysql_connection_details" {
  value = {
    host        = module.mysql_cluster.host_fqdn
    subnet_id   = module.mysql_cluster.host_subnet_id
    user        = module.mysql_cluster.username
    database    = module.mysql_cluster.database_name
    port        = 3306
  }
  description = "Детали подключения к MySQL"
}