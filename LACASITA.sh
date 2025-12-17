#!/bin/bash
clear

# Verificación de Root segura
if [ `whoami` != 'root' ]; then
     echo -e "\e[1;31mPARA PODER USAR EL INSTALADOR ES NECESARIO SER ROOT\e[0m"
     echo -e "\e[1;33mDIGITE ESTE COMANDO EN TU TERMINAL: sudo -i\e[0m"
     exit
fi

# Funciones de estética
msg () {
BRAN='\033[1;37m' && VERMELHO='\e[31m' && VERDE='\e[32m' && AMARELO='\e[33m'
AZUL='\e[34m' && MAGENTA='\e[35m' && MAG='\033[1;36m' && NEGRITO='\e[1m' && SEMCOR='\e[0m'
 case $1 in
  -ne)cor="${VERMELHO}${NEGRITO}" && echo -ne "${cor}${2}${SEMCOR}";;
  -ama)cor="${AMARELO}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
  -verm)cor="${AMARELO}${NEGRITO}${VERMELHO}" && echo -e "${cor}${2}${SEMCOR}";;
  -azu)cor="${MAG}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
  -verd)cor="${VERDE}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
  -bra)cor="${BRAN}" && echo -ne "${cor}${2}${SEMCOR}";;
  "-bar2"|"-bar")cor="${VERMELHO}————————————————————————————————————————————————————" && echo -e "${SEMCOR}${cor}${SEMCOR}";;
 esac
}

funbar() {
    comando="$1"
    _=$( $comando >/dev/null 2>&1 ) &
    pid=$!
    while [[ -d /proc/$pid ]]; do
        echo -ne "  \033[1;33m["
        for ((i = 0; i < 20; i++)); do echo -ne "\033[1;31m#"; sleep 0.05; done
        echo -ne "\033[1;33m]"
        tput cuu1 && tput dl1
    done
    echo -e "  \033[1;31m[\033[1;35m>>>>>>>>>>>>>>>>>>>>\033[1;31m] \033[1;32mINSTALADO \033[0m"
}

dependencias() {
  soft="sudo grep less zip unzip ufw curl dos2unix python3 python3-pip openssl cron iptables lsof pv boxes at mlocate gawk bc jq socat netcat-openbsd net-tools cowsay figlet lolcat apache2 screen"
  for i in $soft; do
    echo -e "\033[93m    ❯ \e[97mINSTALANDO PAQUETE \e[36m $i"
    funbar "apt-get install $i -y"
  done
}

install_core_lacasita() {
    clear
    msg -bar2
    echo -ne "\033[1;97m Digite su slogan/nombre: \033[1;32m" && read slogan
    msg -bar2
    
    msg -ama "               Descargando Script Principal ADM-FATHER 2025X"
    
    # Directorios base
    SCPdir="/etc/VPS-MX"
    mkdir -p $SCPdir/protocolos
    mkdir -p $SCPdir/herramientas
    
    cd /etc
    wget -O VPS-MX.tar.gz "https://raw.githubusercontent.com/thefather12/ADM-FATHER2/main/VPS-MX.tar.gz" >/dev/null 2>&1
    tar -xf VPS-MX.tar.gz >/dev/null 2>&1
    rm -rf VPS-MX.tar.gz
    chmod -R 755 $SCPdir

    # ==========================================================
    # PARCHE DINÁMICO DE PROTOCOLOS (TRAER DESDE GITHUB)
    # ==========================================================
    msg -ama "               Sincronizando Protocolos..."
    URL_REPO="https://raw.githubusercontent.com/thefather12/ADM-FATHER2/main/protocolos"
    
    # Intentamos bajar la lista de protocolos para saber qué descargar
    wget -qO /tmp/lista_p.txt "${URL_REPO}/lista_protocolos.txt"
    
    if [ -f /tmp/lista_p.txt ]; then
        for proto in $(cat /tmp/lista_p.txt); do
            echo -e "\e[1;32m    ❯ Descargando: \e[37m$proto"
            wget -O "$SCPdir/protocolos/$proto" "${URL_REPO}/$proto" -q
            chmod +x "$SCPdir/protocolos/$proto"
            # Parche de rutas automático para cada protocolo
            sed -i 's|/root/|/etc/VPS-MX/|g' "$SCPdir/protocolos/$proto" 2>/dev/null
        done
    fi

    # Parche de IP en el Menú Principal
    sed -i 's|wget -qO- ifconfig.me|curl -s ipinfo.io/ip|g' $SCPdir/menu
    sed -i "s|slogan_placeholder|$slogan|g" $SCPdir/menu 2>/dev/null

    # Enlaces directos
    ln -sf /etc/VPS-MX/menu /usr/bin/menu
    ln -sf /etc/VPS-MX/menu /usr/bin/VPSMX
    chmod +x /usr/bin/menu /usr/bin/VPSMX

    echo "$slogan" > /etc/VPS-MX/message.txt
    
    # Versión
    curl -sSL "https://raw.githubusercontent.com/thefather12/ADM-FATHER2/main/Otros/Version" > /etc/versin_script
    
    msg -bar2
    echo -e "\e[1;92m             >> INSTALACION COMPLETADA <<" 
    echo -e "      ESCRIBA EL COMANDO: \033[1;41m  menu  \033[0m"
    msg -bar2
}

# FLUJO PRINCIPAL
msg -bar2
echo -e "   \e[1;97m\e[1;100m =====>>►►  SCRIPT ADM-FATHER (2025X)  ◄◄<<===== \033[0m"
msg -bar2
msg -ama "               PREPARANDO SISTEMA"
apt-get update && apt-get upgrade -y
dependencias
install_core_lacasita

# Reinicio automático
REBOOT_TIMEOUT=10
echo -e "\e[1;97m REINICIANDO EN $REBOOT_TIMEOUT SEGUNDOS (Presione Ctrl+C para cancelar)\e[0m"
sleep 10
reboot
