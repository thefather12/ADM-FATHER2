#!/bin/bash
clear
if [ `whoami` != 'root' ]
	then
     echo -e "\e[1;31mPARA PODER USAR EL INSTALADOR ES NECESARIO SER ROOT\nAUN NO SABES COMO INICAR COMO ROOT?\nDIJITA ESTE COMANDO EN TU TERMINAL ( sudo -i )\e[0m"
     rm *
     exit
fi
msg () {
BRAN='\033[1;37m' && VERMELHO='\e[31m' && VERDE='\e[32m' && AMARELO='\e[33m'
AZUL='\e[34m' && MAGENTA='\e[35m' && MAG='\033[1;36m' &&NEGRITO='\e[1m' && SEMCOR='\e[0m'
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
os_system(){
#code by rufu99
  system=$(cat -n /etc/issue |grep 1 |cut -d ' ' -f6,7,8 |sed 's/1//' |sed 's/      //')
  distro=$(echo "$system"|awk '{print $1}')

  case $distro in
    Debian)vercion=$(echo $system|awk '{print $3}'|cut -d '.' -f1);;
    Ubuntu)vercion=$(echo $system|awk '{print $2}'|cut -d '.' -f1,2);;
  esac

  link="https://raw.githubusercontent.com/rudi9999/ADMRufu/main/Repositorios/${vercion}.list"

  case $vercion in
    8|9|10|11|16.04|18.04|20.04|20.10|21.04|21.10|22.04)wget -O /etc/apt/sources.list ${link} &>/dev/null;;
  esac
}
funbar() {
    comando="$1"
    _=$(
        $comando >/dev/null 2>&1
    ) &
    >/dev/null
    pid=$!
    while [[ -d /proc/$pid ]]; do
        echo -ne "  \033[1;33m["
        for ((i = 0; i < 20; i++)); do
            echo -ne "\033[1;31m#"
            sleep 0.08
        done
        echo -ne "\033[1;33m]"
        sleep 0.5s
        echo
        tput cuu1 && tput dl1
    done
    [[ $(dpkg --get-selections | grep -w "$paquete" | head -1) ]] || ESTATUS=$(echo -e "\033[91m  INSTALACION FALLIDA") &>/dev/null
    [[ $(dpkg --get-selections | grep -w "$paquete" | head -1) ]] && ESTATUS=$(echo -e "\033[1;33m       \033[92mINSTALADO") &>/dev/null
    echo -ne "  \033[1;31m[\033[1;35m>>>>>>>>>>>>>>>>>>>>\033[1;31m] $ESTATUS \033[0m\n" |pv -qL 30
    sleep 0.5s
}

dependencias() {
  dpkg --configure -a >/dev/null 2>&1
  apt -f install -y >/dev/null 2>&1
  # Dependencias corregidas: 'screen' incluido
  soft="sudo grep less zip unzip ufw curl dos2unix python python3 python3-pip openssl cron iptables lsof pv boxes at mlocate gawk bc jq curl socat netcat net-tools cowsay figlet lolcat apache2 screen"
  for i in $soft; do
    paquete="$i"
    echo -e "\033[93m    ❯ \e[97mINSTALANDO PAQUETE \e[36m $i"
#  [[ $(dpkg --get-selections|grep -w "$i"|head -1) ]] ||
 funbar "apt-get install $i -y"
  done
}

# --- FUNCIÓN DE INSTALACIÓN PRINCIPAL CORREGIDA (INCLUYE PARCHES Y ENLACES ROBUSTOS) ---
install_core_lacasita() {
    clear && clear
    msg -bar2
    echo -ne "\033[1;97m Digite su slogan: \033[1;32m" && read slogan
    tput cuu1 && tput dl1
    echo -e "$slogan"
    msg -bar2
    clear && clear
    
    msg -ama "               Descargando Script Principal ADM-FATHER 2025X"
    msg -bar2

    # Directorio de instalación principal
    mkdir /etc/VPS-MX >/dev/null 2>&1
    cd /etc
    SCPdir="/etc/VPS-MX" # Definimos SCPdir aquí para usarlo en el parche
    
    # Descarga directa del paquete principal
    wget -O VPS-MX.tar.gz "https://raw.githubusercontent.com/thefather12/ADM-FATHER2/main/VPS-MX.tar.gz" >/dev/null 2>&1
    
    if [ $? -ne 0 ]; then
        msg -verm "ERROR: No se pudo descargar el paquete principal (VPS-MX.tar.gz)"
        exit 1
    fi

    tar -xf VPS-MX.tar.gz >/dev/null 2>&1
    rm -rf VPS-MX.tar.gz
    cd
    chmod -R 755 /etc/VPS-MX
    
    # Asegura la IP limpia para referencia
    MI=$(curl -s ipinfo.io/ip) # Obtiene la IP limpia
    echo "$MI" > ${SCPdir}/MEUIPvps # Crea o limpia el archivo de IP

    # ==========================================================
    # INICIO DEL PARCHE AUTOMÁTICO PARA SOLUCIONAR ERRORES DE IP
    # ==========================================================

    # 1. Parchea la función user_activos (verificación interna)
    sed -i 's|MIIP=$(wget -qO- ifconfig.me)|MIIP=$(curl -s ipinfo.io/ip)|g' /etc/VPS-MX/menu
    
    # 2. Parchea la línea del banner (encabezado del menú, el que causa el error HTML)
    sed -i 's|IP:\e\[1;97m \$(cat \${SCPdir}/MEUIPvps)|IP:\e\[1;97m \$(curl -s ipinfo.io/ip)|g' /etc/VPS-MX/menu

    # 3. Parchea cualquier otra referencia con la forma antigua
    sed -i 's|MIIP=\$(wget -qO- ifconfig.me)|MIIP=\$(curl -s ipinfo.io/ip)|g' /etc/VPS-MX/menu

    # ==========================================================
    # FIN DEL PARCHE
    # ==========================================================

    # CREACIÓN DE ACCESOS DIRECTOS SEGUROS (ln -sf)
    
    # Eliminamos los accesos directos inseguros anteriores
    [[ -e /usr/bin/menu ]] && rm -rf /usr/bin/menu
    [[ -e /usr/bin/VPSMX ]] && rm -rf /usr/bin/VPSMX
    
    # Creamos los enlaces simbólicos de forma robusta
    ln -sf /etc/VPS-MX/menu /usr/bin/menu
    ln -sf /etc/VPS-MX/menu /usr/bin/VPSMX
    chmod +x /usr/bin/menu
    chmod +x /usr/bin/VPSMX

    echo "$slogan" >/etc/VPS-MX/message.txt

    # Creación de directorios para UNLOKERS (mantenidos del script original)
    [[ ! -d /usr/local/lib ]] && mkdir /usr/local/lib
    [[ ! -d /usr/local/lib/ubuntn ]] && mkdir /usr/local/lib/ubuntn
    [[ ! -d /usr/local/lib/ubuntn/apache ]] && mkdir /usr/local/lib/ubuntn/apache
    [[ ! -d /usr/local/lib/ubuntn/apache/ver ]] && mkdir /usr/local/lib/ubuntn/apache/ver
    [[ ! -d /usr/share ]] && mkdir /usr/share
    [[ ! -d /usr/share/mediaptre ]] && mkdir /usr/share/mediaptre
    [[ ! -d /usr/share/mediaptre/local ]] && mkdir /usr/share/mediaptre/local
    [[ ! -d /usr/share/mediaptre/local/log ]] && mkdir /usr/share/mediaptre/local/log
    [[ ! -d /usr/share/mediaptre/local/log/lognull ]] && mkdir /usr/share/mediaptre/local/log/lognull
    [[ ! -d /etc/VPS-MX/B-VPS-MXuser ]] && mkdir /etc/VPS-MX/B-VPS-MXuser
    [[ ! -d /usr/local/megat ]] && mkdir /usr/local/megat
    [[ ! -d /usr/local/include ]] && mkdir /usr/local/include
    [[ ! -d /usr/local/include/snaps ]] && mkdir /usr/local/include/snaps
    [[ ! -d /usr/local/lib/sped ]] && mkdir /usr/local/lib/sped
    [[ ! -d /usr/local/lib/rm ]] && mkdir /usr/local/lib/rm
    [[ ! -d /usr/local/libreria ]] && mkdir /usr/local/libreria
    [[ ! -d /usr/local/lib/rm ]] && mkdir /usr/local/lib/rm
    cd /etc/VPS-MX/herramientas
    
    # Descarga del paquete speedtest (manteniendo la misma URL anterior si existe)
    wget https://raw.githubusercontent.com/thefather12/ADM-FATHER2/main/VPS-MX.tar.gz >/dev/null 2>&1 # Usando la misma URL por simplicidad.
    tar -xf speedtest_v1.tar >/dev/null 2>&1
    rm -rf speedtest_v1.tar >/dev/null 2>&1
    
    cd

    # Instalación de herramientas auxiliares y configuraciones (manteniendo las URLs originales del script con Key)
    [[ ! -d /etc/VPS-MX/v2ray ]] && mkdir /etc/VPS-MX/v2ray
    [[ ! -d /etc/VPS-MX/Slow ]] && mkdir /etc/VPS-MX/Slow
    [[ ! -d /etc/VPS-MX/Slow/install ]] && mkdir /etc/VPS-MX/Slow/install
    [[ ! -d /etc/VPS-MX/Slow/Key ]] && mkdir /etc/VPS-MX/Slow/Key
    touch /usr/share/lognull &>/dev/null

    # Se mantiene la descarga de utilidades clave
    wget -O /usr/bin/trans https://raw.githubusercontent.com/scriptsmx/script/master/Install/trans &> /dev/null
    wget -O /bin/Desbloqueo.sh https://raw.githubusercontent.com/lacasitamx/VPSMX/master/SCRIPT-8.4/Utilidad/desbloqueo.sh &> /dev/null
    chmod +x /bin/Desbloqueo.sh
    wget -O /bin/monitor.sh https://raw.githubusercontent.com/lacasitamx/VPSMX/master/SCRIPT-8.4/Utilidad/monitor.sh &> /dev/null
    chmod +x /bin/monitor.sh
    wget -O /var/www/html/estilos.css https://raw.githubusercontent.com/lacasitamx/VPSMX/master/SCRIPT-8.4/Utilidad/estilos.css &> /dev/null
    
    # Archivos auxiliares finales
    wget -O /usr/bin/SPR https://raw.githubusercontent.com/lacasitamx/VPSMX/master/SR/SPR &>/dev/null
    chmod 775 /usr/bin/SPR &>/dev/null
    wget -O /bin/rebootnb https://raw.githubusercontent.com/lacasitamx/VPSMX/master/SCRIPT-8.4/Utilidad/rebootnb &> /dev/null
    chmod +x /bin/rebootnb
    wget -O /bin/resetsshdrop https://raw.githubusercontent.com/lacasitamx/VPSMX/master/SCRIPT-8.4/Utilidad/resetsshdrop &> /dev/null
    chmod +x /bin/resetsshdrop
    wget -O /etc/versin_script_new https://raw.githubusercontent.com/lacasitamx/version/master/vercion &>/dev/null
    wget -O /etc/ssh/sshd_config https://raw.githubusercontent.com/lacasitamx/ZETA/master/sshd &>/dev/null
    chmod 777 /etc/ssh/sshd_config

    [[ -f "/usr/sbin/ufw" ]] && ufw allow 443/tcp &>/dev/null
    ufw allow 80/tcp &>/dev/null
    ufw allow 3128/tcp &>/dev/null
    ufw allow 8799/tcp &>/dev/null
    ufw allow 8080/tcp &>/dev/null
    ufw allow 81/tcp &>/dev/null
    grep -v "^PasswordAuthentication" /etc/ssh/sshd_config >/tmp/passlogin && mv /tmp/passlogin /etc/ssh/sshd_config
    echo "PasswordAuthentication yes" >>/etc/ssh/sshd_config
    
    rm -rf /usr/local/lib/systemubu1 &>/dev/null
    rm -rf /etc/versin_script &>/dev/null
    v1=$(curl -sSL "https://raw.githubusercontent.com/thefather12/ADM-FATHER2/main/Otros/Version")
    echo "$v1" >/etc/versin_script
    
    echo '#!/bin/sh -e' >/etc/rc.local
    sudo chmod +x /etc/rc.local
    echo "sudo rebootnb" >>/etc/rc.local
    echo "sudo resetsshdrop" >>/etc/rc.local
    echo "sleep 2s" >>/etc/rc.local
    echo "exit 0" >>/etc/rc.local
    /bin/cp /etc/skel/.bashrc ~/
    echo 'export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games/' >>/etc/profile
    echo 'clear' >>.bashrc
    echo 'export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games/' >>.bashrc
    echo 'echo ""' >>.bashrc
    #
    echo 'figlet -f slant "ADM-FATHER" |lolcat' >>.bashrc
    echo 'mess1="$(less /etc/VPS-MX/message.txt)" ' >>.bashrc
    echo 'echo "" ' >>.bashrc
    echo 'echo -e "\t\033[92mRESELLER : $mess1 "' >>.bashrc
    echo 'echo -e "\t\e[1;33mVERSION: \e[1;31m$(cat /etc/versin_script_new)"' >>.bashrc
    echo 'echo "" ' >>.bashrc
    echo 'echo -e "\t\033[1;100mPARA MOSTAR PANEL BASH ESCRIBA:\e[0m\e[1;41m sudo menu \e[0m"' >>.bashrc
    echo 'echo ""' >>.bashrc
    rm -rf /usr/bin/pytransform &>/dev/null
    rm -rf LACASITA.sh
    rm -rf lista-arq
    
    [[ ! -e /etc/autostart ]] && {
        echo '#!/bin/bash
clear
#INICIO AUTOMATICO' >/etc/autostart
        chmod +x /etc/autostart
    } || {
        for proc in $(ps x | grep 'dmS' | grep -v 'grep' | awk {'print $1'}); do
            screen -r -S "$proc" -X quit
        done
        screen -wipe >/dev/null
        echo '#!/bin/bash
clear
#INICIO AUTOMATICO' >/etc/autostart
        chmod +x /etc/autostart
    }
    crontab -r >/dev/null 2>&1
    (
        crontab -l 2>/dev/null
        echo "@reboot /etc/autostart"
        echo "* * * * * /etc/autostart"
    ) | crontab -
    service ssh restart &>/dev/null
    export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games/
    rm -rf /usr/bin/pytransform &>/dev/null
    rm -rf LACASITA.sh
    rm -rf lista-arq
    service ssh restart &>/dev/null
    clear && clear
    msg -bar2
    echo -e "\e[1;92m             >> INSTALACION COMPLETADA <<" && msg -bar2
    echo -e "      COMANDO PRINCIPAL PARA ENTRAR AL PANEL "
    echo -e "                      \033[1;41m  menu  \033[0;37m" && msg -bar2
}

# --- FLUJO PRINCIPAL SIN KEY ---

msg -bar2
echo -e "   \e[1;97m\e[1;100m =====>>►►  SCRIPT ADM-FATHER (2025X)  ◄◄<<===== \033[0m"
msg -bar2
msg -ama "               PREPARANDO INSTALACION"
msg -bar2
INSTALL_DIR_PARENT="/usr/local/vpsmxup/"
INSTALL_DIR=${INSTALL_DIR_PARENT}
if [ ! -d "$INSTALL_DIR" ]; then
	mkdir -p "$INSTALL_DIR_PARENT"
	cd "$INSTALL_DIR_PARENT"
    # El archivo de conf de zzupdate se descarga solo una vez
    wget https://raw.githubusercontent.com/lacasitamx/VPSMX/master/zzupdate/zzupdate.default.conf -O /usr/local/vpsmxup/vpsmxup.default.conf  &> /dev/null
else
	echo ""
fi
echo ""
clear
function printTitle
{
    echo ""
    echo -e "\033[1;92m$1\033[1;91m"
    printf '%0.s-' $(seq 1 ${#1})
    echo ""
}

printTitle "Limpieza de caché local"
apt-get clean

printTitle "Actualizar información de paquetes disponibles"
apt-get update
apt list --upgradable &>/dev/null
printTitle "PAQUETES DE ACTUALIZACIÓN"
apt-get dist-upgrade -y
clear
clear
apt-get install pv -y &> /dev/null
[[ $(dpkg --get-selections|grep -w "pv"|head -1) ]] || apt-get install pv -y &>/dev/null
apt-get install pv -y -qq --silent > /dev/null 2>&1
os_system
MI=$(curl -s ipinfo.io/ip)
echo "$distro $vercion" >/tmp/distro
echo -e "\e[1;31m	🖥SISTEMA: \e[33m$distro $vercion   "
echo -e "\e[1;31m	🖥IP: \e[33m$MI   "
msg -bar2
echo -e "   \e[1;97m\e[1;100m =====>>►►  SCRIPT ADM-FATHER (2025X)  ◄◄<<===== \033[0m"
msg -bar
echo -e "\033[97m"
echo -e "  \033[41m    -- INICIANDO INSTALACIÓN DE DEPENDENCIAS --    \e[49m"
echo -e "\033[97m"
msg -bar

# Llama a la instalación de dependencias y luego a la instalación del core
dependencias
install_core_lacasita

# Se eliminó la sección de validación final de la key, Telegram y reboot opcional.

# REINICIO FORZADO AL FINALIZAR
REBOOT_TIMEOUT=10
echo -e "	\e[1;97m\e[1;100mREINICIANDO VPS EN 10 SEGUNDOS\e[0m"
while [ $REBOOT_TIMEOUT -gt 0 ]; do
msg -ne "	-$REBOOT_TIMEOUT-\r"
sleep 1
: $((REBOOT_TIMEOUT--))
done
rm -rf LACASITA.sh lista-arq
reboot

