# templates/compose.yaml.tpl
version: '3.8'

services:
  web:
    extra_hosts:
      - "${mysql_host}:${mysql_ip}"
    environment:
      DB_HOST: "${mysql_host}"
      DB_USER: "${mysql_user}"
      DB_PASSWORD: "${mysql_password}"
      DB_NAME: "${mysql_database}"
