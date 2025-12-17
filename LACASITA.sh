#!/bin/bash
# ==========================================================
# INSTALADOR DE REPARACIÓN DE PROTOCOLOS - ADM-FATHER 2025X
# ==========================================================

clear
SCPdir="/etc/VPS-MX"
USER_GIT="thefather12"
REPO_GIT="ADM-FATHER2"
BRANCH="main"
URL_RAW="https://raw.githubusercontent.com/${USER_GIT}/${REPO_GIT}/${BRANCH}"

echo -e "\e[1;32m[*] Iniciando reparación de rutas de protocolos...\e[0m"

# 1. Crear estructura completa y archivos de sistema
mkdir -p $SCPdir/protocolos
mkdir -p $SCPdir/controlador
mkdir -p $SCPdir/tmp
mkdir -p /usr/local/include/snaps
mkdir -p /usr/local/lib/rm
mkdir -p /usr/local/lib/sped
cd /root && mkdir -p cd

# Crear archivos de soporte para evitar errores visuales
touch $SCPdir/controlador/tiemlim.log
echo "1" > $SCPdir/tmp/style

# 2. Descargar el Menú Principal
wget -q -O $SCPdir/menu "${URL_RAW}/VPS-MX/menu" || wget -q -O $SCPdir/menu "${URL_RAW}/menu"
chmod +x $SCPdir/menu
ln -sf $SCPdir/menu /usr/bin/menu

# 3. Descarga y Reparación de Protocolos (v2ray.sh, etc.)
msg_inst() { echo -e "\e[1;32m    ❯ $1\e[0m"; }

wget -qO /tmp/lista_p.txt "${URL_RAW}/protocolos/lista_protocolos.txt"

if [ -f /tmp/lista_p.txt ]; then
    for proto in $(cat /tmp/lista_p.txt); do
        msg_inst "Instalando: $proto"
        wget -q -O "$SCPdir/protocolos/$proto" "${URL_RAW}/protocolos/$proto"
        chmod +x "$SCPdir/protocolos/$proto"
        
        # --- EL PARCHE CLAVE ---
        # Muchos scripts se cierran porque buscan archivos en /root/ o rutas viejas.
        # Este comando cambia todas las rutas internas para que coincidan con tu servidor.
        sed -i "s|/root/|$SCPdir/|g" "$SCPdir/protocolos/$proto" 2>/dev/null
        sed -i "s|/etc/vps-mx/|$SCPdir/|g" "$SCPdir/protocolos/$proto" 2>/dev/null
    done
fi

# 4. Verificación especial para V2RAY (si no está en la lista)
if [ ! -f "$SCPdir/protocolos/v2ray.sh" ]; then
    msg_inst "Descarga forzada de v2ray.sh..."
    wget -q -O "$SCPdir/protocolos/v2ray.sh" "${URL_RAW}/protocolos/v2ray.sh"
    chmod +x "$SCPdir/protocolos/v2ray.sh"
fi

echo -e "\e[1;32m------------------------------------------------------\e[0m"
echo -e "  PROTOCOLOS SINCRONIZADOS Y RUTAS REPARADAS."
echo -e "\e[1;32m------------------------------------------------------\e[0m"
echo -e "Escribe: \e[1;42m menu \e[0m"

