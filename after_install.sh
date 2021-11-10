#!/usr/bin/env bash

main() 
{
    echo '----------------------Настойка после установки-------------------------'
    if [[ $(id -u) -eq 0 ]] ; then
        echo '1) Обновление системы...'
        apt update && apt dist-upgrade && apt install git wget curl
        echo '2) подключение репозиториев Debian...'
        apt install debian-archive-keyring dirmngr
        apt-key adv --recv-keys --keyserver keys.gnupg.net EF0F382A1A7B6500
        echo "deb https://download.astralinux.ru/astra/testing/orel/repository orel contrib main non-free" > /etc/apt/sources.list
        echo "deb https://mirror.yandex.ru/debian/ stretch main contrib non-free" >> /etc/apt/sources.list 
        echo "deb [arch=amd64] http://repo.yandex.ru/yandex-browser/deb beta main" >> /etc/apt/sources.list.d/yandex-browser.list
        wget https://repo.yandex.ru/yandex-browser/YANDEX-BROWSER-KEY.GPG && sudo apt-key add YANDEX-BROWSER-KEY.GPG
        echo "3) Обновление ..."
        apt update
        echo "4) установка программ ..."
        apt install yandex-browser-beta && {
            mkdir /tmp/install_glibc/
            cd /tmp/install_glibc/
            wget http://ftp.ru.debian.org/debian/pool/main/g/glibc/libc6_2.28-10_amd64.deb
            wget http://ftp.ru.debian.org/debian/pool/main/g/glibc/locales_2.28-10_all.deb
            wget http://ftp.ru.debian.org/debian/pool/main/g/glibc/libc-l10n_2.28-10_all.deb
            wget http://ftp.ru.debian.org/debian/pool/main/g/glibc/libc-bin_2.28-10_amd64.deb
            wget http://ftp.ru.debian.org/debian/pool/main/g/glibc/libc-dev-bin_2.28-10_amd64.deb
            wget http://ftp.ru.debian.org/debian/pool/main/g/glibc/libc6-dev_2.28-10_amd64.deb
            wget http://ftp.ru.debian.org/debian/pool/main/g/glibc/libc6-dbg_2.28-10_amd64.deb
            wget http://ftp.ru.debian.org/debian/pool/main/g/glibc/libc6-i386_2.28-10_amd64.deb
            dpkg -i *
            cd ~
            rm -rf /tmp/install_glibc/
            source /opt/yandex/browser-beta/update-ffmpeg
        }
        apt install gcc g++ gdb make cmake snapd
        snap install core
    else 
        echo -e "Для работы скрипта требуются права 'root' !"
    fi
    echo "Установка завершена..."
    return 0
}

main
