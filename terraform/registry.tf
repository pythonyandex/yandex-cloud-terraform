resource "yandex_container_registry" "app_registry" {
  name      = "app-registry"
  folder_id = var.yc_folder_id
  
  labels = {
    environment = "production"
    project     = "netology"
  }
}

output "container_registry_id" {
  value = yandex_container_registry.app_registry.id
}

output "container_registry_url" {
  value = "cr.yandex/${yandex_container_registry.app_registry.id}"
}