#!/bin/bash
# ==========================================================
# INSTALADOR COMPLETO - SOLUCIÓN DE CIERRE PREMATURO
# ==========================================================

clear
SCPdir="/etc/VPS-MX"
USER_GIT="thefather12"
REPO_GIT="ADM-FATHER2"
BRANCH="main"
URL_RAW="https://raw.githubusercontent.com/${USER_GIT}/${REPO_GIT}/${BRANCH}"

echo -e "\e[1;33m[*] Creando carpetas de seguridad requeridas por el menú...\e[0m"
# Estos directorios son obligatorios para que el menú no haga 'exit'
mkdir -p /usr/local/include/snaps
mkdir -p /usr/local/lib/rm
mkdir -p /usr/local/lib/sped
mkdir -p $SCPdir/protocolos
mkdir -p $SCPdir/herramientas

echo -e "\e[1;33m[*] Descargando archivos desde GitHub...\e[0m"
# Descarga del menú (asegúrate de que esté en la raíz o en la carpeta VPS-MX de tu repo)
wget -q -O $SCPdir/menu "${URL_RAW}/VPS-MX/menu" || wget -q -O $SCPdir/menu "${URL_RAW}/menu"

if [ -s "$SCPdir/menu" ]; then
    chmod +x $SCPdir/menu
    # Crear enlaces simbólicos
    ln -sf $SCPdir/menu /usr/bin/menu
    ln -sf $SCPdir/menu /usr/bin/vpsmx
    
    # Crear archivos de versión básicos para evitar errores de lectura
    echo "1.0" > /etc/versin_script
    echo "1.0" > /etc/versin_script_new
    
    echo -e "\e[1;32m[OK] Instalación terminada.\e[0m"
    echo -e "Escribe \e[1;42m menu \e[0m para iniciar."
else
    echo -e "\e[1;31m[ERROR] No se pudo descargar el archivo 'menu'. Revisa tu repositorio.\e[0m"
fi

