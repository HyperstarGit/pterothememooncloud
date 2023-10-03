#!/bin/bash

BLUE='\033[0;34m'.
NO_COLOR='\033[0m'

if (( $EUID != 0 )); then
    echo "Por favor run com root"
    exit
fi

clear

installTheme(){
    cd /var/www/
    tar -cvf pterothememooncloud.tar.gz pterodactyl
    echo "Instalando tema.."
    cd /var/www/pterodactyl
    rm -r pterothememooncloud
    git clone https://github.com/markosvr/pterothememooncloud.git
    cd pterothememooncloud
    rm /var/www/pterodactyl/resources/scripts/IceMinecraftTheme.css
    rm /var/www/pterodactyl/resources/scripts/index.tsx
    rm /var/www/pterodactyl/resources/scripts/components/server/console/Console.tsx
    mv resources/scripts/index.tsx /var/www/pterodactyl/resources/scripts/index.tsx
    mv resources/scripts/IceMinecraftTheme.css /var/www/pterodactyl/resources/scripts/IceMinecraftTheme.css
    mv resources/scripts/components/server/console/Console.tsx /var/www/pterodactyl/resources/scripts/components/server/console/Console.tsx
    cd /var/www/pterodactyl

    curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
    apt update
    apt install -y nodejs

    npm i -g yarn
    yarn
    export NODE_OPTIONS=--openssl-legacy-provider
    cd /var/www/pterodactyl
    yarn build:production
    sudo php artisan optimize:clear


}

installThemeQuestion(){
    while true; do
        read -p "Certeza que quer instalar o tema? [y/N]? " yn
        case $yn in
            [Yy]* ) installTheme; break;;
            [Nn]* ) exit;;
            * ) exit;;
        esac
    done
}

repair(){
    bash <(curl https://raw.githubusercontent.com/Angelillo15/IceMinecraftTheme/main/repair.sh)
}

restoreBackUp(){
    echo "Restaurando o backup..."
    cd /var/www/
    tar -xvf pterothememooncloud.tar.gz
    rm IceMinecraftTheme.tar.gz

    cd /var/www/pterodactyl
    yarn build:production
    sudo php artisan optimize:clear
}
                                                                                                                           
printf "${blue} Mooncloud-theme \n"
echo ""
echo "Copyright (c) 2023 Angelillo15 | angelillo15.es"
echo "This program is free software: you can redistribute it and/or modify"
echo ""
echo "Discord: https://nop"
echo "Website: https://angelillo15.es/"
echo ""
echo "[1] Instalar tema"
echo "[2] Restaurar backup"
echo "[3] Reparar"
echo "[4] Atualizar panel"
echo "[5] Sair"
printf "${NO_COLOR}"

read -p "Please enter a number: " choice
if [ $choice == "1" ]
    then
    installThemeQuestion
fi
if [ $choice == "2" ]
    then
    restoreBackUp
fi
if [ $choice == "3" ]
    then
    repair
fi
if [ $choice == "4" ]
    then
    repair
fi
if [ $choice == "5" ]
    then
    exit
fi
