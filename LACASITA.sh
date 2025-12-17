#!/bin/bash
# ==========================================================
# INSTALADOR MAESTRO ADM-FATHER - VERSIÓN FINAL COMPLETA
# ==========================================================

clear
# 1. VERIFICACIÓN DE SEGURIDAD (ROOT)
if [ `whoami` != 'root' ]; then
     echo -e "\e[1;31mERROR: DEBES SER USUARIO ROOT PARA INSTALAR\e[0m"
     echo -e "\e[1;33mUSA EL COMANDO: sudo -i\e[0m"
     exit 1
fi

# 2. CONFIGURACIÓN DEL REPOSITORIO
USER_GIT="thefather12"
REPO_GIT="ADM-FATHER2"
BRANCH="main"
URL_RAW="https://raw.githubusercontent.com/${USER_GIT}/${REPO_GIT}/${BRANCH}"
SCPdir="/etc/VPS-MX"

# 3. DEFINICIÓN DE COLORES Y ESTÉTICA
msg () {
  BRAN='\033[1;37m' && VERMELHO='\e[31m' && VERDE='\e[32m' && AMARELO='\e[33m'
  AZUL='\e[34m' && MAG='\033[1;36m' && NEGRITO='\e[1m' && SEMCOR='\e[0m'
  case $1 in
    -ama) echo -e "${AMARELO}${NEGRITO}${2}${SEMCOR}";;
    -verm) echo -e "${VERMELHO}${NEGRITO}${2}${SEMCOR}";;
    -azu) echo -e "${AZUL}${NEGRITO}${2}${SEMCOR}";;
    -bar) echo -e "${VERMELHO}————————————————————————————————————————————————————${SEMCOR}";;
  esac
}

funbar() {
    comando="$1"
    _=$( $comando >/dev/null 2>&1 ) &
    pid=$!
    while [[ -d /proc/$pid ]]; do
        echo -ne "  \033[1;33m["
        for ((i = 0; i < 20; i++)); do echo -ne "\033[1;31m#"; sleep 0.03; done
        echo -ne "\033[1;33m]"
        tput cuu1 && tput dl1
    done
    echo -e "  \033[1;31m[\033[1;35m>>>>>>>>>>>>>>>>>>>>\033[1;31m] \033[1;32mINSTALADO \033[0m"
}

# 4. INSTALACIÓN DE DEPENDENCIAS
dependencias() {
  msg -bar
  msg -ama " INSTALANDO PAQUETES NECESARIOS"
  msg -bar
  soft="sudo grep less zip unzip ufw curl dos2unix python3 python3-pip openssl cron iptables lsof pv boxes at mlocate gawk bc jq socat netcat-openbsd net-tools cowsay figlet lolcat apache2 screen"
  for i in $soft; do
    echo -ne "\033[93m    ❯ \e[97m$i: "
    funbar "apt-get install $i -y"
  done
}

# 5. FUNCIÓN DE DESCARGA INDIVIDUAL
download_file() {
    local folder=$1
    local file=$2
    local dest=$3
    
    # Si folder es "VPS-MX", busca en la carpeta principal del repo
    url_final="${URL_RAW}/${folder}/${file}"

    wget -q -O "${dest}/${file}" "$url_final"
    
    if [ $? -eq 0 ]; then
        chmod +x "${dest}/${file}"
        echo -e "\e[1;32m    ❯ Descargado: \e[37m${file}"
    else
        echo -e "\e[1;31m    ❯ Error: \e[37m${file} (No encontrado)"
    fi
}

# 6. INSTALACIÓN DEL CORE
install_core() {
    clear
    msg -bar
    echo -e "   \e[1;97m\e[1;100m  INSTALADOR DIRECTO: ADM-FATHER 2025X  \033[0m"
    msg -bar
    echo -ne "\033[1;97m Digite su slogan/nombre: \033[1;32m" && read slogan
    msg -bar
    
    msg -ama " Limpiando y preparando directorios..."
    rm -rf $SCPdir
    mkdir -p $SCPdir/protocolos
    mkdir -p $SCPdir/herramientas
    mkdir -p /usr/local/include/snaps
    
    # Descargar MENU (Desde carpeta VPS-MX en GitHub)
    msg -ama " Instalando Menú Principal..."
    download_file "VPS-MX" "menu" "$SCPdir"

    # Descargar PROTOCOLOS (Desde carpeta protocolos en GitHub)
    msg -ama " Sincronizando Protocolos..."
    wget -qO /tmp/lista_p.txt "${URL_RAW}/protocolos/lista_protocolos.txt"
    
    if [ -f /tmp/lista_p.txt ]; then
        for proto in $(cat /tmp/lista_p.txt); do
            download_file "protocolos" "$proto" "$SCPdir/protocolos"
            sed -i 's|/root/|/etc/VPS-MX/|g' "$SCPdir/protocolos/$proto" 2>/dev/null
        done
    else
        # Descarga forzada de v2ray si no hay lista
        download_file "protocolos" "v2ray.sh" "$SCPdir/protocolos"
    fi

    # Configuración de accesos y Banner
    echo "$slogan" > $SCPdir/message.txt
    ln -sf $SCPdir/menu /usr/bin/menu
    ln -sf $SCPdir/menu /usr/bin/vpsmx
    chmod +x $SCPdir/menu /usr/bin/menu
    
    # Guardar IP y Versión
    curl -s ipinfo.io/ip > $SCPdir/MEUIPvps
    wget -qO /etc/versin_script "${URL_RAW}/Otros/Version"

    msg -bar
    echo -e "\e[1;92m INSTALACIÓN COMPLETADA CON ÉXITO"
    echo -e "\e[1;37m COMANDO PRINCIPAL: \e[1;42m menu \e[0m"
    msg -bar
}

# ==========================================================
# 7. EJECUCIÓN DEL SCRIPT (FLUJO FINAL)
# ==========================================================
# Actualizar lista de paquetes
apt-get update

# Llamar a la instalación de dependencias
dependencias

# Llamar a la descarga e instalación de archivos
install_core

# Reinicio opcional
REBOOT_TIMEOUT=5
echo -e "\e[1;37m El sistema se reiniciará en $REBOOT_TIMEOUT segundos..."
sleep 5
reboot
