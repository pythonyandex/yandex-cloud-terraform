module "mysql_cluster" {
  source = "./mysql-cluster"

  # Обязательные параметры
  cluster_name = "app-mysql-cluster"
  network_id   = yandex_vpc_network.app-network.id
  username     = "app_user"
  password     = var.mysql_password  # Определите в variables.tf

  # Подсети для хостов (минимум одна)
  subnets = [
    {
      id   = yandex_vpc_subnet.app-subnet-a.id
      zone = "ru-central1-a"
    },
    # Для HA можно добавить вторую подсеть
    # {
    #   id   = yandex_vpc_subnet.app-subnet-b.id
    #   zone = "ru-central1-b"
    # }
  ]

  # Опционально: группа безопасности
  security_group_ids = [yandex_vpc_security_group.app-sg.id]

  # Опционально: параметры БД
  database_name = "app_database"
  environment   = "PRODUCTION"  # или "PRESTABLE"

  # Опционально: ресурсы
  resource_preset_id = "s2.micro"  # 2 vCPU, 8 GB RAM
  disk_size          = 20
  disk_type_id       = "network-ssd"

  # Опционально: HA режим
  ha_mode = false  # true для высокой доступности

  # Опционально: метки
  labels = {
    project     = "netology"
    application = "web-app"
  }
}