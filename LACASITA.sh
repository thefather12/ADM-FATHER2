#!/bin/bash
# ==========================================================
# INSTALADOR REPARADOR - ADM-FATHER 2025X
# ==========================================================

clear
SCPdir="/etc/VPS-MX"
USER_GIT="thefather12"
REPO_GIT="ADM-FATHER2"
BRANCH="main"
URL_RAW="https://raw.githubusercontent.com/${USER_GIT}/${REPO_GIT}/${BRANCH}"

# Forzar la creación de la carpeta de seguridad para el menú
mkdir -p /usr/local/include/snaps
mkdir -p $SCPdir/protocolos

msg_inst() {
  echo -e "\e[1;32m[INSTALADOR]\e[0m $1"
}

# 1. Reparar comandos si faltan
if ! command -v ls &> /dev/null; then
    apt-get update && apt-get install coreutils wget curl -y
fi

# 2. Descarga Directa con verificación de errores
# Intentamos bajar el menú. Si falla en VPS-MX, busca en la raíz
msg_inst "Descargando Menú Principal..."
wget -q -O $SCPdir/menu "${URL_RAW}/VPS-MX/menu" || wget -q -O $SCPdir/menu "${URL_RAW}/menu"

if [ ! -s "$SCPdir/menu" ]; then
    echo -e "\e[1;31mERROR: No se pudo descargar el archivo 'menu'.\e[0m"
    echo -e "Verifica que el archivo esté en: ${URL_RAW}/VPS-MX/menu"
    exit 1
fi

# 3. Descarga de Protocolos
msg_inst "Descargando Protocolos..."
wget -qO /tmp/lista_p.txt "${URL_RAW}/protocolos/lista_protocolos.txt"

if [ -f /tmp/lista_p.txt ]; then
    for proto in $(cat /tmp/lista_p.txt); do
        wget -q -O "$SCPdir/protocolos/$proto" "${URL_RAW}/protocolos/$proto"
        chmod +x "$SCPdir/protocolos/$proto"
        echo -e "  \e[1;32m✔\e[0m $proto"
    done
else
    # Si no hay lista, forzamos v2ray
    wget -q -O "$SCPdir/protocolos/v2ray.sh" "${URL_RAW}/protocolos/v2ray.sh"
    chmod +x "$SCPdir/protocolos/v2ray.sh"
fi

# 4. Crear el comando 'menu' de forma absoluta
chmod +x $SCPdir/menu
ln -sf $SCPdir/menu /usr/bin/menu
ln -sf $SCPdir/menu /usr/bin/vpsmx

msg_inst "INSTALACIÓN FINALIZADA"
echo -e "Escribe: \e[1;42m menu \e[0m"
