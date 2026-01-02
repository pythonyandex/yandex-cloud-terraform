module "mysql_cluster" {
  source = "./mysql-cluster"

  cluster_name = "app-mysql-cluster"
  network_id   = yandex_vpc_network.app-network.id
  username     = "app_user"
  password     = var.mysql_password 

  subnets = [
    {
      id   = yandex_vpc_subnet.app-subnet-a.id
      zone = "ru-central1-a"
    },
    # Для ha_mode
    # {
    #   id   = yandex_vpc_subnet.app-subnet-b.id
    #   zone = "ru-central1-b"
    # }
  ]

  security_group_ids = [yandex_vpc_security_group.app-sg.id]

  database_name = "app_database"
  environment   = "PRODUCTION"  

  resource_preset_id = "s2.micro"  # 2 vCPU, 8 GB RAM
  disk_size          = 20
  disk_type_id       = "network-ssd"

  ha_mode = false 

  labels = {
    project     = "netology"
    application = "web-app"
  }
}