#!/bin/bash
# ==========================================================
# INSTALADOR DINÁMICO ADM-FATHER - VERSIÓN MEJORADA
# ==========================================================

clear
# 1. VERIFICACIÓN DE SEGURIDAD (ROOT)
if [ `whoami` != 'root' ]; then
     echo -e "\e[1;31mERROR: DEBES SER USUARIO ROOT PARA INSTALAR\e[0m"
     echo -e "\e[1;33mUSA EL COMANDO: sudo -i\e[0m"
     exit 1
fi

# 2. DEFINICIÓN DE COLORES Y ESTÉTICA
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
        for ((i = 0; i < 20; i++)); do echo -ne "\033[1;31m#"; sleep 0.04; done
        echo -ne "\033[1;33m]"
        tput cuu1 && tput dl1
    done
    echo -e "  \033[1;31m[\033[1;35m>>>>>>>>>>>>>>>>>>>>\033[1;31m] \033[1;32mINSTALADO \033[0m"
}

# 3. INSTALACIÓN DE DEPENDENCIAS ESENCIALES
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

# 4. INSTALACIÓN DEL CORE Y SINCRONIZACIÓN DE CAMBIOS
install_core_lacasita() {
    clear
    msg -bar
    echo -ne "\033[1;97m Digite su slogan o nombre de marca: \033[1;32m" && read slogan
    msg -bar
    
    SCPdir="/etc/VPS-MX"
    
    # LIMPIEZA TOTAL PARA REPARAR REPOS (Elimina versiones viejas)
    msg -ama " Reparando y Limpiando archivos antiguos..."
    rm -rf $SCPdir/protocolos
    mkdir -p $SCPdir/protocolos
    mkdir -p $SCPdir/herramientas
    mkdir -p /usr/local/include/snaps # Clave de acceso del menú
    
    msg -ama " Descargando Paquete Principal (vía GitHub)..."
    cd /etc
    wget -q -O VPS-MX.tar.gz "https://raw.githubusercontent.com/thefather12/ADM-FATHER2/main/VPS-MX.tar.gz"
    tar -xf VPS-MX.tar.gz >/dev/null 2>&1
    rm -rf VPS-MX.tar.gz
    
    # SINCRONIZACIÓN DE CAMBIOS EN PROTOCOLOS (v2ray, ssl, etc)
    msg -ama " Forzando descarga de nuevos protocolos..."
    URL_REPO="https://raw.githubusercontent.com/thefather12/ADM-FATHER2/main/protocolos"
    
    # Bajamos la lista de protocolos activos en tu repo
    wget -qO /tmp/lista_p.txt "${URL_REPO}/lista_protocolos.txt"
    
    if [ -f /tmp/lista_p.txt ]; then
        for proto in $(cat /tmp/lista_p.txt); do
            echo -e "\e[1;32m    ❯ Sincronizando: \e[37m$proto"
            # Descarga limpia directamente del RAW de GitHub
            wget -q -O "$SCPdir/protocolos/$proto" "${URL_REPO}/$proto"
            chmod +x "$SCPdir/protocolos/$proto"
            
            # PARCHE DE RUTAS INTERNAS (Corrige errores de scripts que apuntan a /root/)
            sed -i 's|/root/|/etc/VPS-MX/|g' "$SCPdir/protocolos/$proto" 2>/dev/null
        done
    fi

    # Configuración de accesos y Banner
    echo "$slogan" > $SCPdir/message.txt
    ln -sf $SCPdir/menu /usr/bin/menu
    ln -sf $SCPdir/menu /usr/bin/vpsmx
    chmod +x $SCPdir/menu /usr/bin/menu
    
    # Actualización de versión
    curl -sSL "https://raw.githubusercontent.com/thefather12/ADM-FATHER2/main/Otros/Version" > /etc/versin_script
    
    msg -bar
    echo -e "\e[1;92m       >> REPOS REPARADOS Y ACTUALIZADOS <<" 
    echo -e "\e[1;37m        ACCESO AL PANEL: \e[1;41m  menu  \e[0m"
    msg -bar
}

# 5. INICIO DEL PROCESO
msg -bar
echo -e "   \e[1;97m\e[1;100m =====>>►►  SCRIPT ADM-FATHER (2025X)  ◄◄<<===== \033[0m"
msg -bar
apt-get update && apt-get upgrade -y
dependencias
install_core_lacasita

# Reinicio de cortesía para aplicar cambios de kernel/red
REBOOT_TIMEOUT=5
echo -e "\e[1;37m Reiniciando sistema en $REBOOT_TIMEOUT seg para finalizar...\e[0m"
sleep 5
reboot
