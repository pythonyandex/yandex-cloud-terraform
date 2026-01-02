output "cluster_id" {
  description = "ID созданного кластера MySQL"
  value       = yandex_mdb_mysql_cluster.this.id
}

# Убраны ошибочные атрибуты. Добавлены полезные выходные данные.
output "cluster_name" {
  description = "Имя кластера"
  value       = yandex_mdb_mysql_cluster.this.name
}

output "created_at" {
  description = "Время создания кластера"
  value       = yandex_mdb_mysql_cluster.this.created_at
}

output "status" {
  description = "Текущий статус кластера"
  value       = yandex_mdb_mysql_cluster.this.status
}

# Вывод информации о хостах (ID и зоны)
output "hosts" {
  description = "Список хостов кластера"
  value = [for host in yandex_mdb_mysql_cluster.this.host : {
    zone = host.zone
    # subnet_id = host.subnet_id # При необходимости
  }]
}

output "database_name" {
  description = "Имя созданной базы данных"
  value       = var.database_name
}

output "username" {
  description = "Имя пользователя БД"
  value       = var.username
  sensitive   = true
}
output "hosts_ips" {
  value = [for h in yandex_mdb_mysql_cluster.this.host : 
    h.assign_public_ip ? "Has public IP" : "Internal IP only"
  ]
  description = "Information about host IP addresses"
}
output "primary_host_fqdn" {
  value       = yandex_mdb_mysql_cluster.this.host[0].fqdn
  description = "Primary host FQDN"
}

output "host_fqdn" {
  value       = yandex_mdb_mysql_cluster.this.host[0].fqdn
  description = "Host FQDN"
}

output "hosts_count" {
  value       = length(yandex_mdb_mysql_cluster.this.host)
  description = "Number of hosts in cluster"
}

output "database_info" {
  value = {
    name     = var.database_name
    username = var.username
  }
  description = "Database information"
  sensitive   = true
}
output "host_subnet_id" {
  value       = yandex_mdb_mysql_cluster.this.host[0].subnet_id
  description = "Subnet ID хоста MySQL"
}

output "host_network_info" {
  value = {
    fqdn            = yandex_mdb_mysql_cluster.this.host[0].fqdn
    zone            = yandex_mdb_mysql_cluster.this.host[0].zone
    subnet_id       = yandex_mdb_mysql_cluster.this.host[0].subnet_id
    has_public_ip   = yandex_mdb_mysql_cluster.this.host[0].assign_public_ip
  }
  description = "Сетевая информация о хосте MySQL"
}
output "password" {
  description = "MySQL password"
  value       = yandex_mdb_mysql_user.this.password
  sensitive   = true
}
