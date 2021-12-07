#!/usr/bin/env bash

list_e=()
list_i=()
list_i+=("gcc" "g++" "make" "cmake" "gdb" "git" "wget" "curl")
upgrade_s () {
    local up_=$(apt update && apt dist-upgrade)
}

add_soft() {
    for i in "${list_i[@]}" 
    do    
        local res_=$(apt install $i)
    done
}

add_yandex() {
    echo "deb https://mirror.yandex.ru/debian/ stretch main contrib non-free" >> /etc/apt/sources.list 
    echo "deb [arch=amd64] http://repo.yandex.ru/yandex-browser/deb beta main" >> /etc/apt/sources.list.d/yandex-browser.list
    wget https://repo.yandex.ru/yandex-browser/YANDEX-BROWSER-KEY.GPG && sudo apt-key add YANDEX-BROWSER-KEY.GPG
    source /opt/yandex/browser-beta/update-ffmpeg
    upgrade_s
}

set_base() {
    echo '----------------------Настойка источников-------------------------'
    echo '-----------------подключение репозиториев Debian...'
    apt install debian-archive-keyring dirmngr
    apt-key adv --recv-keys --keyserver keys.gnupg.net EF0F382A1A7B6500
    echo "deb https://download.astralinux.ru/astra/testing/orel/repository orel contrib main non-free" > /etc/apt/sources.list
    echo "deb https://mirror.yandex.ru/debian/ stretch main contrib non-free" >> /etc/apt/sources.list
    upgrade_s
    echo '----------------------Настойка после установки-------------------------'
    sleep 3
}


set_lib() {
    echo '----------------------Установка пакетов-------------------------'
     local f_=$(
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
            upgrade_s
         )
    echo '----------------------Настойка после установки-------------------------'
    sleep 3
}

main() 
{
    if [[ $(id -u) -eq 0 ]] ; then
    while [[ "$#" -gt 0 ]] 
    do
        case "$1" in 
        'base') set_base ;;
        'lib') set_lib ;;
        'yandex') add_yandex ;;
        'soft') add_soft ;;
        *) echo "Некоректные параметры!" ;;
        esac
        shift    
    done    
    else 
        echo -e "Для работы скрипта требуются права 'root' !"
    fi
    echo "Установка завершена..."
    return 0
}

main "$@"
