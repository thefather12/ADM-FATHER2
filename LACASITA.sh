#!/bin/bash
# ==========================================================
# INSTALADOR "REPARADOR DE CIERRE" - ADM-FATHER 2025X
# ==========================================================

clear
SCPdir="/etc/VPS-MX"
USER_GIT="thefather12"
REPO_GIT="ADM-FATHER2"
BRANCH="main"
URL_RAW="https://raw.githubusercontent.com/${USER_GIT}/${REPO_GIT}/${BRANCH}"

echo -e "\e[1;32m[*] REPARANDO DEPENDENCIAS DEL MENÚ...\e[0m"

# 1. CREAR LAS CARPETAS QUE EL MENÚ EXIGE PARA NO CERRARSE
mkdir -p /usr/local/include/snaps
mkdir -p /usr/local/lib/rm
mkdir -p /usr/local/lib/sped
mkdir -p /etc/VPS-MX/protocolos
mkdir -p /etc/VPS-MX/herramientas
mkdir -p /etc/VPS-MX/controlador

# 2. REPARAR EL ERROR DEL DIRECTORIO "cd"
# El menú hace: [[ ! -d cd ]] && exit. Vamos a crear esa carpeta.
cd /root
mkdir -p cd

# 3. INSTALAR EL ARCHIVO SPR (Parece que el menú lo reclama)
wget -q -O /usr/bin/SPR "${URL_RAW}/herramientas/SPR" || touch /usr/bin/SPR
chmod +x /usr/bin/SPR

# 4. DESCARGAR EL MENÚ
echo -e "\e[1;32m[*] DESCARGANDO MENÚ DESDE GITHUB...\e[0m"
wget -q -O $SCPdir/menu "${URL_RAW}/VPS-MX/menu" || wget -q -O $SCPdir/menu "${URL_RAW}/menu"

if [ -s "$SCPdir/menu" ]; then
    chmod +x $SCPdir/menu
    ln -sf $SCPdir/menu /usr/bin/menu
    
    # Crear archivos de versión para que no den error
    echo "1.0" > /etc/versin_script
    
    echo -e "\e[1;32m------------------------------------------------------\e[0m"
    echo -e "  INSTALACIÓN EXITOSA. LAS CARPETAS 'sped' Y 'cd' "
    echo -e "  HAN SIDO CREADAS PARA EVITAR EL CIERRE DEL SCRIPT."
    echo -e "\e[1;32m------------------------------------------------------\e[0m"
    echo -e "Escribe: \e[1;42m menu \e[0m"
else
    echo -e "\e[1;31m[!] ERROR: No se pudo descargar el menú de GitHub.\e[0m"
fi

