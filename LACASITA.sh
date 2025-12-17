#!/bin/bash
# ==========================================================
# INSTALADOR DE RESCATE - ADM-FATHER 2025X
# ==========================================================

clear
if [ `whoami` != 'root' ]; then
     echo -e "\e[1;31mERROR: DEBES SER ROOT\e[0m"
     exit 1
fi

# CONFIGURACIÓN (Verifica que estas rutas existan en tu GitHub)
USER_GIT="thefather12"
REPO_GIT="ADM-FATHER2"
BRANCH="main"
URL_RAW="https://raw.githubusercontent.com/${USER_GIT}/${REPO_GIT}/${BRANCH}"
SCPdir="/etc/VPS-MX"

msg () {
  echo -e "\e[1;33m$1\e[0m"
}

# FUNCIÓN DE DESCARGA MEJORADA
download_file() {
    local folder=$1 # Carpeta en GitHub (ej. VPS-MX o protocolos)
    local file=$2   # Nombre del archivo (ej. menu o v2ray.sh)
    local dest=$3   # Carpeta destino en el VPS

    # Intentamos descargar
    wget -q -O "${dest}/${file}" "${URL_RAW}/${folder}/${file}"
    
    if [ -s "${dest}/${file}" ]; then
        chmod +x "${dest}/${file}"
        echo -e "\e[1;32m [OK] \e[37m${file} instalado en ${dest}"
    else
        echo -e "\e[1;31m [FALLO] \e[37m${file} no se encontró en GitHub o está vacío."
        rm -f "${dest}/${file}"
    fi
}

install_core() {
    msg "Preparando directorios..."
    rm -rf $SCPdir
    mkdir -p $SCPdir/protocolos
    mkdir -p $SCPdir/herramientas
    mkdir -p /usr/local/include/snaps # Requisito de tu menú

    msg "Descargando Menú y Protocolos..."
    
    # IMPORTANTE: Aquí indico que el archivo 'menu' está dentro de la carpeta 'VPS-MX' en tu GitHub
    download_file "VPS-MX" "menu" "$SCPdir"
    
    # Descargar protocolos usando la lista
    wget -qO /tmp/lista_p.txt "${URL_RAW}/protocolos/lista_protocolos.txt"
    if [ -f /tmp/lista_p.txt ]; then
        for proto in $(cat /tmp/lista_p.txt); do
            download_file "protocolos" "$proto" "$SCPdir/protocolos"
        done
    fi

    # --- REPARACIÓN DEL ACCESO DIRECTO ---
    msg "Configurando comando 'menu'..."
    rm -f /usr/bin/menu
    rm -f /usr/bin/vpsmx
    
    # Creamos el enlace simbólico apuntando a la ruta real
    if [ -f "$SCPdir/menu" ]; then
        ln -sf $SCPdir/menu /usr/bin/menu
        ln -sf $SCPdir/menu /usr/bin/vpsmx
        chmod +x /usr/bin/menu
        echo -e "\e[1;32m Comando 'menu' vinculado correctamente.\e[0m"
    else
        echo -e "\e[1;31m ERROR CRÍTICO: El archivo 'menu' no existe en $SCPdir\e[0m"
    fi
}

# EJECUCIÓN
apt-get update && apt-get install wget curl -y &>/dev/null
install_core

msg "Instalación finalizada. Prueba escribiendo: menu"

