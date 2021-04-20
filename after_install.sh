#!/usr/bin/env bash

main() 
{
    echo '1) Обновление системы...'
    sudo apt update && apt dist-upgrade
    echo '2) подключение репозиториев Debian...'
    sudo apt install debian-archive-keyring dirmngr
    sudo apt-key adv --recv-keys --keyserver keys.gnupg.net EF0F382A1A7B6500
    sudo echo '"deb https://download.astralinux.ru/astra/testing/orel/repository orel contrib main non-free" > /etc/apt/sources.list'
    sudo echo '"deb https://mirror.yandex.ru/debian/ stretch main contrib non-free" >> /etc/apt/sources.list' 
    echo "3) Обновление ..."
    sudo apt update
    echo "4) установка программ ..."
    sudo apt install gcc g++ gdb make cmake git wget curl snapd
    sudo snap install core 
    echo "Установка завершена..."
    return 0
}

main