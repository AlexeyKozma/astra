#!/usr/bin/env bash

main() 
{
    echo '----------------------Настойка после установки-------------------------'
    if [[ $(id -u) -eq 0 ]] ; then
        echo '1) Обновление системы...'
        apt update && apt dist-upgrade
        echo '2) подключение репозиториев Debian...'
        apt install debian-archive-keyring dirmngr
        apt-key adv --recv-keys --keyserver keys.gnupg.net EF0F382A1A7B6500
        echo "deb https://download.astralinux.ru/astra/testing/orel/repository orel contrib main non-free" > /etc/apt/sources.list
        echo "deb https://mirror.yandex.ru/debian/ stretch main contrib non-free" >> /etc/apt/sources.list 
        echo "3) Обновление ..."
        apt update
        echo "4) установка программ ..."
        apt install gcc g++ gdb make cmake git wget curl snapd
        snap install core 
    else 
        echo -e "Для работы скрипта требуются права 'root' !"
    fi
    echo "Установка завершена..."
    return 0
}

main
