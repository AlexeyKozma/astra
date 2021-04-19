#!/usr/bin/env bash

main() 
{
    echo '----------------------Настойка после установки-------------------------'
    echo '1) Обновление системы...'
    sudo su apt update && apt dist-upgrade
    echo '2) подключение репозиториев Debian...'
    apt install debian-archive-keyring dirmngr
    apt-key adv --recv-keys --keyserver keys.gnupg.net EF0F382A1A7B6500
    echo "deb https://download.astralinux.ru/astra/testing/orel/repository orel contrib main non-free" > /etc/apt/sources.list
    echo "deb https://mirror.yandex.ru/debian/ stretch main contrib non-free" >> /etc/apt/sources.list 
    echo "3) Обновление ..."
    apt update && exit
    echo "4) установка программ ..."
    sudo apt install gcc g++ gdb make cmake git wget curl snapd
    sudo snap install core 
    echo "Установка завершена..."
    return 0
}

main