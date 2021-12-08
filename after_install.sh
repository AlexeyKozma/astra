#!/usr/bin/env bash

dir_build="/tmp/"
list_e=()
list_i=()
list_i+=("gcc" "g++" "make" "cmake" "gdb" "git" "wget" "curl")
upgrade_s () {
    local up_=$(apt update && apt dist-upgrade)
    sleep 1
}

add_soft() {
    for i in "${list_i[@]}" 
    do    
        apt install "$i" 
    done
    sleep 1
}


add_yandex() {
    echo "deb https://mirror.yandex.ru/debian/ stretch main contrib non-free" >> /etc/apt/sources.list 
    echo "deb [arch=amd64] http://repo.yandex.ru/yandex-browser/deb beta main" >> /etc/apt/sources.list.d/yandex-browser.list
    wget https://repo.yandex.ru/yandex-browser/YANDEX-BROWSER-KEY.GPG && sudo apt-key add YANDEX-BROWSER-KEY.GPG
    source /opt/yandex/browser-beta/update-ffmpeg
    upgrade_s
    sleep 1
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
    sleep 1
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
    sleep 1
}

install_i3 () {
    local wm_="i3-wm"
    list_i=()
    echo "----------------------Подготовка к установке $wm_--------------------------"
    list_i+=("meson" "dh-autoreconf" "libxcb-keysyms1-dev" "libpango1.0-dev" "libxcb-util0-dev" "xcb" "libxcb1-dev" "libxcb-icccm4-dev" "libyajl-dev" "libev-dev" "libxcb-xkb-dev" 
    "libxcb-cursor-dev" "libxkbcommon-dev" "libxcb-xinerama0-dev" "libxkbcommon-x11-dev" "libstartup-notification0-dev" "libxcb-randr0-dev" "libxcb-xrm0" "libxcb-xrm-dev" "libxcb-shape0" "libxcb-shape0-dev"
    "i3" "xorg" "suckless-tools" "lightdm" "rofi" "firefox-esr" "wicd" "cups" "xfce4-power-manager" "conky" "htop" "pulseaudio" "pavucontrol" "alsa-utils" "xbindkeys" "arandr" "xbacklight" "feh" "compton" 
    "snapd" "numlockx" "unclutter" "cmus" "ufw")
    add_soft
    echo "----------------------Процесс загрузки с github.com --------------------------" 
    echo "----------------------переход в директорию сборки ----------------------------"              
    local in_i3=$(cd "$dir_build" && git clone https://github.com/Airblader/i3.git i3-gaps)
    if [[ "$in_i3" -eq 0 ]] 
    then
       echo "------------------- Каталог проекта скачен ----------------------------------"
       local build_=$(
                    chown -Rf "$user" i3-gaps
                    cd i3-gaps
                    mkdir -p build && cd build
                    meson --prefix /usr/local)                 
       if [[ "$build_" -eq 0 ]] ; then
            echo "-----------------Сборка завершилась успешно-----------------------"
            echo "----------------------Процесс установки $wm_--------------------------" 
            local install_res=$(ninja
                    sudo ninja install)
            if [[ $install_res -eq 0 ]] ; then
                echo "-------------------Настройка после установи------------------------"
                echo "exec i3" > "$HOME"/.xinitrc
                numlockx on
            fi       
       else 
            echo "Ошибка при сборке!"     
       fi 
    else 
        echo "Ошибка при скачивании!"     
    fi
    echo "----------------------Завершение установки $wm_ --------------------------" 
    cd                
    sleep 1
}

install_fm () {
    echo "----------------------Установка файлового менеджера"
    list_i=()
    list_i+=("pcmanfm-qt" "pcmanfm-qt-l10n" "libfm-qt3")
    add_soft
    sleep 1
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
        'i3') install_i3 ;;
        'fm') install_fm ;;
        *) echo "Некорректные параметры!" ;;
        esac
        shift    
    done    
    else 
        echo "Для работы скрипта требуются права 'root' !"
    fi
    echo "Установка завершена..."
    return 0
}

main "$@"

