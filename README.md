# Terraform инфраструктура для Yandex Cloud

## Описание
Проект развертывает инфраструктуру в Yandex Cloud:
- Виртуальная машина с Ubuntu
- Managed MySQL кластер
- Container Registry
- Сетевая инфраструктура (VPC, Security Groups)

## Задание 1. Развертывание инфраструктуры в Yandex Cloud.

    Создайте Virtual Private Cloud (VPC).
    Создайте подсети.
    Создайте виртуальные машины (VM):
        Настройте группы безопасности (порты 22, 80, 443).
        Привяжите группу безопасности к VM.
    Опишите создание БД MySQL в Yandex Cloud.
    Опишите создание Container Registry.

## Решение 1.
Ресурсы создаются здесь (main.tf)[https://github.com/pythonyandex/yandex-cloud-terraform/blob/main/terraform/main.tf]

## Задание 2. Используя user-data (cloud-init), установите Docker и Docker Compose (см. Задания 5 модуля «Виртуализация и контейнеризация»).
## Решение 2. 
На первом этапе описал процесс поднятия ubuntu и установку туда docker, docker compose при помощи cloud-init.yml. Прошло успешно. Ресурсы создаются здесь (main.tf)[https://github.com/pythonyandex/yandex-cloud-terraform/blob/main/terraform/main.tf].
 
## Задание 3. Опишите Docker файл (см. Задания 5 «Виртуализация и контейнеризация») c web-приложением и сохраните контейнер в Container Registry.
## Решение 3.
Я использовал свое предыдущие [задание](https://github.com/pythonyandex/shvirtd-test/tree/main) с развертыванием Веб и БД для записи ip адресов, перенес установку в [cloud-init.yml](https://github.com/pythonyandex/yandex-cloud-terraform/blob/main/terraform/cloud-init.yml), происходит клонирование репозитория и поднятия сервисов. Надо отключить создание БД и переключить на YDB.

## Задание 4. Завяжите работу приложения в контейнере на БД в Yandex Cloud.

## Решение 4.
Для переключения на на БД в Yandex Cloud был добавлен [mysql.tf](https://github.com/pythonyandex/yandex-cloud-terraform/blob/main/terraform/mysql.tf). 
Для корректной настоойки приложения, я сделал клон - [shvirtd-test_YDB_Mysql](https://github.com/pythonyandex/shvirtd-test_YDB_Mysql/tree/main) своего репозитория из задания 3, указал в compose.yaml использование Yandex БД. Terraform при развертывании APP и Yandex БД одновременно, при помощи cloud-init.yml БД меняется в compose.yaml  на новосозданную БД. Подскажите, пожалуйста, как можно сделать правильно?
