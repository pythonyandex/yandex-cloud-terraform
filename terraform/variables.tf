variable "yc_token" {
  description = "Yandex Cloud OAuth token"
  type        = string
  sensitive   = true
}

variable "yc_cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
}

variable "yc_folder_id" {
  description = "Yandex Cloud folder ID"
  type        = string
}

variable "db_password" {
  description = "MySQL database password"
  type        = string
  sensitive   = true
}
variable "mysql_password" {
  description = "Password for MySQL database user"
  type        = string
  sensitive   = true
  default     = "SecurePass123!"  # В реальном проекте используйте terraform.tfvars
}
