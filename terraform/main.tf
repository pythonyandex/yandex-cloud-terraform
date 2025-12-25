# Создание VPC
resource "yandex_vpc_network" "app-network" {
  name = "app-network"
}

# Создание подсетей
resource "yandex_vpc_subnet" "app-subnet-a" {
  name           = "app-subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.app-network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

#resource "yandex_vpc_subnet" "app-subnet-b" {
#  name           = "app-subnet-b"
#  zone           = "ru-central1-b"
#  network_id     = yandex_vpc_network.app-network.id
#  v4_cidr_blocks = ["192.168.20.0/24"]
#}

# Группа безопасности
resource "yandex_vpc_security_group" "app-sg" {
  name        = "app-security-group"
  network_id  = yandex_vpc_network.app-network.id
  description = "Security group for web application"

  ingress {
    protocol       = "TCP"
    description    = "SSH access"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    protocol       = "TCP"
    description    = "HTTP access"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "HTTPS access"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }
  
  ingress {
    protocol       = "TCP"
    description    = "8090 access"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 8090
  }

  ingress {
    protocol       = "TCP"
    description    = "MySQL access"
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.20.0/24"]
    port           = 3306
  }

  ingress {
    protocol       = "TCP"
    description    = "HAProxy reverse proxy"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 8080  # ← ДОБАВЬТЕ ЭТО!
  }

  ingress {
    protocol       = "TCP"
    description    = "Web app direct"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 5000  # ← И ЭТО!
  }
  egress {
    protocol       = "ANY"
    description    = "Outbound traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

# ВМ для приложения
resource "yandex_compute_instance" "app-vm" {
  name        = "app-vm"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd827b91d99psvq5fjit" # Ubuntu 22.04
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.app-subnet-a.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.app-sg.id]
  }
#  provisioner "file" {
#    source      = "/home/ruslan/main_work/docker"  # Локальная директория
#    destination = "/home/ubuntu/"  # Директория на ВМ
#  }
  
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    user-data = "${file("${path.module}/cloud-init.yml")}"
  }
}


# Static IP для VM
#resource "yandex_vpc_address" "app-address" {
#  name = "app-static-ip"

#3  external_ipv4_address {
#    zone_id = "ru-central1-a"
  #}
#}
