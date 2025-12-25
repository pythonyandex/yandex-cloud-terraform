variable "cluster_name" {
  description = "Имя кластера MySQL"
  type        = string
}

variable "network_id" {
  description = "ID сети для размещения кластера"
  type        = string
}

variable "subnets" {
  description = "Список подсетей для размещения хостов"
  type = list(object({
    id   = string
    zone = string
  }))
}

variable "ha_mode" {
  description = "Режим высокой доступности"
  type        = bool
  default     = false
}

variable "environment" {
  description = "Окружение"
  type        = string
  default     = "PRESTABLE"
}

variable "database_name" {
  description = "Имя базы данных"
  type        = string
  default     = "default_db"
}

variable "username" {
  description = "Имя пользователя"
  type        = string
}

variable "password" {
  description = "Пароль пользователя"
  type        = string
  sensitive   = true
}

variable "security_group_ids" {
  description = "ID групп безопасности"
  type        = list(string)
  default     = []
}

variable "deletion_protection" {
  description = "Защита от удаления"
  type        = bool
  default     = false
}

variable "mysql_version" {
  description = "Версия MySQL"
  type        = string
  default     = "8.0"
}

variable "labels" {
  description = "Метки"
  type        = map(string)
  default     = {}
}

variable "resource_preset_id" {
  description = "Пресет ресурсов"
  type        = string
  default     = "s2.micro"
}

variable "disk_type_id" {
  description = "Тип диска"
  type        = string
  default     = "network-ssd"
}

variable "disk_size" {
  description = "Размер диска (GB)"
  type        = number
  default     = 10
}

variable "backup_window_start" {
  description = "Время начала бэкапа"
  type = object({
    hours   = number
    minutes = number
  })
  default = {
    hours   = 23
    minutes = 59
  }
}

variable "backup_retain_period_days" {
  description = "Период хранения бэкапов"
  type        = number
  default     = 7
}
