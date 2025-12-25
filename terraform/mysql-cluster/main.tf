resource "yandex_mdb_mysql_cluster" "this" {
  name                = var.cluster_name
  environment         = var.environment
  network_id          = var.network_id
  security_group_ids  = var.security_group_ids
  deletion_protection = var.deletion_protection
  version             = var.mysql_version

  labels = merge({
    terraform   = "true"
    environment = lower(var.environment)
    module      = "mysqlcluster"
  }, var.labels)

  resources {
    resource_preset_id = var.resource_preset_id
    disk_type_id       = var.disk_type_id
    disk_size          = var.disk_size
  }

  maintenance_window {
    type = "ANYTIME"
  }

  backup_window_start {
    hours   = var.backup_window_start.hours
    minutes = var.backup_window_start.minutes
  }

  backup_retain_period_days = var.backup_retain_period_days

  mysql_config = {
    sql_mode                      = "ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION"
    max_connections               = 100
    default_authentication_plugin = "MYSQL_NATIVE_PASSWORD"
    innodb_print_all_deadlocks    = true
  }

  # Первый хост (обязательный)
  host {
    zone      = var.subnets[0].zone
    subnet_id = var.subnets[0].id
  }

  # Второй хост для HA
  dynamic "host" {
    for_each = var.ha_mode && length(var.subnets) > 1 ? [1] : []
    
    content {
      zone      = var.subnets[1].zone
      subnet_id = var.subnets[1].id
    }
  }
}
resource "yandex_mdb_mysql_database" "this" {
  cluster_id = yandex_mdb_mysql_cluster.this.id
  name       = var.database_name
}

# Отдельный ресурс для пользователя
resource "yandex_mdb_mysql_user" "this" {
  cluster_id = yandex_mdb_mysql_cluster.this.id
  name       = var.username
  password   = var.password
  permission {
    database_name = yandex_mdb_mysql_database.this.name
    roles         = ["ALL"]
  }

  
  

  authentication_plugin = "MYSQL_NATIVE_PASSWORD"
}


