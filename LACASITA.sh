#!/bin/bash
# INSTALADOR LACASITAMX-v9x MODIFICADO
# BASE: INSTALADO --- ACTULIZADO EL 12-01-2023 --By @Kalix1
clear && clear
colores="$(pwd)/colores"
rm -rf ${colores}
wget -O ${colores} "https://raw.githubusercontent.com/eze1087/Multi/main/Otros/colores" &>/dev/null
[[ ! -e ${colores} ]] && exit
chmod +x ${colores} &>/dev/null
source ${colores}

CTRL_C() {
  rm -rf ${colores}
  rm -rf /root/LATAM
  exit
}
trap "CTRL_C" INT TERM EXIT
#rm $(pwd)/$0 &>/dev/null

#-- VERIFICAR ROOT
if [ $(whoami) != 'root' ]; then
  echo ""
  echo -e "\e[1;31m NECESITAS SER USER ROOT PARA EJECUTAR EL SCRIPT \n\n\e[97m                DIGITE: \e[1;32m sudo su\n"
  exit
fi

os_system() {
  system=$(cat -n /etc/issue | grep 1 | cut -d ' ' -f6,7,8 | sed 's/1//' | sed 's/      //')
  distro=$(echo "$system" | awk '{print $1}')

  case $distro in
  Debian) vercion=$(echo $system | awk '{print $3}' | cut -d '.' -f1) ;;
  Ubuntu) vercion=$(echo $system | awk '{print $2}' | cut -d '.' -f1,2) ;;
  esac
}

repo() {
  link="https://raw.githubusercontent.com/eze1087/Multi/main/Source-List/$1.list"
  case $1 in
  8 | 9 | 10 | 11 | 16.04 | 18.04 | 20.04 | 20.10 | 21.04 | 21.10 | 22.04) wget -O /etc/apt/sources.list ${link} &>/dev/null ;;
  esac
}

## PRIMER PASO DE INSTALACION
install_inicial() {
  clear && clear
  #--VERIFICAR IP MANUAL
  tu_ip() {
    echo ""
    echo -ne "\e[1;96m #Digite tu IP Publica (IPV4): \e[32m" && read IP
    val_ip() {
      local ip=$IP
      local stat=1
      if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
      fi
      return $stat
    }
    if val_ip $IP; then
      echo "$IP" >/root/.ssh/authrized_key.reg
    else
      echo ""
      echo -e "\e[31mLa IP Digitada no es valida, Verifiquela"
      echo ""
      sleep 5s
      fun_ip
    fi
  }
  #CONFIGURAR SSH-ROOT PRINCIPAL AMAZON, GOOGLE
  pass_root() {
    wget -O /etc/ssh/sshd_config https://raw.githubusercontent.com/eze1087/Multi/main/Otros/sshd_config >/dev/null 2>&1
    chmod +rwx /etc/ssh/sshd_config
    service ssh restart
    msgi -bar
    echo -ne "\e[1;97m DIGITE NUEVA CONTRASEÑA:  \e[1;31m" && read pass
    (
      echo $pass
      echo $pass
    ) | passwd root 2>/dev/null
    sleep 1s
    msgi -bar
    echo -e "\e[1;94m     CONTRASEÑA AGREGADA O EDITADA CORECTAMENTE"
    echo -e "\e[1;97m TU CONTRASEÑA ROOT AHORA ES: \e[41m $pass \e[0;37m"

  }
  #-- VERIFICAR VERSION
  v1=$(curl -sSL "https://raw.githubusercontent.com/eze1087/Multi/main/Vercion")
  echo "$v1" >/etc/version_instalacion
  v22=$(cat /etc/version_instalacion)
  vesaoSCT="\e[1;31m [ \e[1;32m( $v22 )\e[1;97m\e[1;31m ]"
  #-- CONFIGURACION BASICA
  os_system
  repo "${vercion}"
  msgi -bar2
  echo -e " \e[5m\e[1;100m   =====>> ►►     MULTI SCRIPT     ◄◄ <<=====    \e[1;37m"
  msgi -bar2
  #-- VERIFICAR VERSION
  msgi -ama "   PREPARANDO INSTALACION | VERSION: $vesaoSCT"
  ## PAQUETES-UBUNTU PRINCIPALES
  echo ""
  echo -e "\e[1;97m         🔎 IDENTIFICANDO SISTEMA OPERATIVO"
  echo -e "\e[1;32m                 | $distro $vercion |"
  echo ""
  echo -e "\e[1;97m        ◽️ DESACTIVANDO PASS ALFANUMERICO "
  [[ $(dpkg --get-selections | grep -w "libpam-cracklib" | head -1) ]] || barra_intallb "apt-get install libpam-cracklib -y &>/dev/null"
  echo -e '# Modulo Pass Simple
password [success=1 default=ignore] pam_unix.so obscure sha512
password requisite pam_deny.so
password required pam_permit.so' >/etc/pam.d/common-password && chmod +x /etc/pam.d/common-password
  [[ $(dpkg --get-selections | grep -w "libpam-cracklib" | head -1) ]] && barra_intallb "date"
  service ssh restart > /dev/null 2>&1 
  echo ""
  msgi -bar2
  fun_ip() {
    TUIP=$(wget -qO- ifconfig.me)
    echo "$TUIP" >/root/.ssh/authrized_key.reg
    echo -e "\e[1;97m ESTA ES TU IP PUBLICA? \e[32m$TUIP"
    msgi -bar2
    echo -ne "\e[1;97m Seleccione  \e[1;31m[\e[1;93m S \e[1;31m/\e[1;93m N \e[1;31m]\e[1;97m: \e[1;93m" && read tu_ip
    #read -p " Seleccione [ S / N ]: " tu_ip
    [[ "$tu_ip" = "n" || "$tu_ip" = "N" ]] && tu_ip
  }
  fun_ip
  msgi -bar2
  echo -e "\e[1;93m             AGREGAR Y EDITAR PASS ROOT\e[1;97m"
  msgi -bar
  echo -e "\e[1;97m CAMBIAR PASS ROOT? \e[32m"
  msgi -bar2
  echo -ne "\e[1;97m Seleccione  \e[1;31m[\e[1;93m S \e[1;31m/\e[1;93m N \e[1;31m]\e[1;97m: \e[1;93m" && read pass_root
  #read -p " Seleccione [ S / N ]: " tu_ip
  [[ "$pass_root" = "s" || "$pass_root" = "S" ]] && pass_root
  msgi -bar2
  echo -e "\e[1;93m\a\a\a      SE PROCEDERA A INSTALAR LAS ACTULIZACIONES\n PERTINENTES DEL SISTEMA, ESTE PROCESO PUEDE TARDAR\n VARIOS MINUTOS Y PUEDE PEDIR ALGUNAS CONFIRMACIONES \e[0;37m"
  msgi -bar
  read -t 120 -n 1 -rsp $'\e[1;97m           Preciona Enter Para continuar\n'
  clear && clear
  apt update
  wget -O /usr/bin/install https://raw.githubusercontent.com/eze1087/Multi/main/0-Instalador/install.sh &>/dev/null
  chmod +rwx /usr/bin/install
}

time_reboot() {
  clear && clear
  msgi -bar
  echo -e "\e[1;93m     CONTINUARA INSTALACION DESPUES DEL REBOOT"
  echo -e "\e[1;93m         O EJECUTE EL COMANDO: \e[1;92mLATAM -c "
  msgi -bar
  REBOOT_TIMEOUT="$1"
  while [ $REBOOT_TIMEOUT -gt 0 ]; do
    print_center -ne "-$REBOOT_TIMEOUT-\r"
    sleep 1
    : $((REBOOT_TIMEOUT--))
  done
  reboot
}

dependencias() {
  dpkg --configure -a >/dev/null 2>&1
  apt -f install -y >/dev/null 2>&1
  soft="sudo bsdmainutils zip unzip ufw curl python python3 python3-pip openssl cron iptables lsof pv boxes at mlocate gawk bc jq curl npm nodejs socat netcat netcat-traditional net-tools cowsay figlet lolcat apache2"
  for i in $soft; do
    paquete="$i"
    echo -e "\e[1;97m INSTALANDO PAQUETE \e[93m >>> \e[36m $i"
    barra_intall "apt-get install $i -y"
  done
}

install_paquetes() {
  clear && clear
  /bin/cp /etc/skel/.bashrc ~/
  #------- BARRA DE ESPERA
  msgi -bar2
  echo -e " \e[5m\e[1;100m   =====>> ►►     MULTI SCRIPT     ◄◄ <<=====    \e[1;37m"
  msgi -bar
  echo -e "  \e[1;41m      -- INSTALACION DE PAQUETES MULTI --      \e[49m"
  msgi -bar
  dependencias
  sed -i "s;Listen 80;Listen 81;g" /etc/apache2/ports.conf >/dev/null 2>&1
  service apache2 restart >/dev/null 2>&1
  [[ $(sudo lsof -i :81) ]] || ESTATUSP=$(echo -e "\e[1;91m      >>>  FALLO DE INSTALACION EN APACHE <<<") &>/dev/null
  [[ $(sudo lsof -i :81) ]] && ESTATUSP=$(echo -e "\e[1;92m          PUERTO APACHE ACTIVO CON EXITO") &>/dev/null
  echo ""
  echo -e "$ESTATUSP"
  echo ""
  echo -e "\e[1;97m        REMOVIENDO PAQUETES OBSOLETOS - \e[1;32m OK"
  apt autoremove -y &>/dev/null
  echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
  echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections
  msgi -bar2
  read -t 30 -n 1 -rsp $'\e[1;97m           Preciona Enter Para continuar\n'
}

#SELECTOR DE INSTALACION (Simplificado para llamar directamente a la instalación de paquetes)
while :; do
  case $1 in
  -s | --start)
    install_inicial && install_paquetes
    break
    ;;
  -c | --continue)
    install_paquetes
    break
    ;;
  -m | --menu)
    break
    ;;
  *) 
    # Si no se dan argumentos, ejecuta el inicializador y la instalación de paquetes.
    install_inicial && install_paquetes 
    break
    ;;
  esac
done

#LACASITA V9 - FUNCIÓN PRINCIPAL DE INSTALACIÓN
install_LACASITA_90() {
  clear && clear
  msgi -bar2
  echo -ne "\033[1;97m Digite su slogan: \033[1;32m" && read slogan
  tput cuu1 && tput dl1
  echo -e "$slogan"
  msgi -bar2
  clear && clear
  mkdir /etc/VPS-MX >/dev/null 2>&1
  cd /etc
  wget https://raw.githubusercontent.com/thefather12/ADM-FATHER2/main/VPS-MX.tar.gz >/dev/null 2>&1
  tar -xf VPS-MX.tar.gz >/dev/null 2>&1
  chmod +x VPS-MX.tar.gz >/dev/null 2>&1
  rm -rf VPS-MX.tar.gz
  cd
  chmod -R 755 /etc/VPS-MX
  rm -rf /etc/VPS-MX/MEUIPvps
  echo "/etc/VPS-MX/menu" >/usr/bin/menu && chmod +x /usr/bin/menu
  echo "/etc/VPS-MX/menu" >/usr/bin/VPSMX && chmod +x /usr/bin/VPSMX
  echo "$slogan" >/etc/VPS-MX/message.txt
  #UNLOKERS
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
  wget https://raw.githubusercontent.com/thefather12/ADM-FATHER2/main/VPS-MX.tar.gz >/dev/null 2>&1
  tar -xf speedtest_v1.tar >/dev/null 2>&1
  rm -rf speedtest_v1.tar >/dev/null 2>&1
  cd
  [[ ! -d /etc/VPS-MX/v2ray ]] && mkdir /etc/VPS-MX/v2ray
  [[ ! -d /etc/VPS-MX/Slow ]] && mkdir /etc/VPS-MX/Slow
  [[ ! -d /etc/VPS-MX/Slow/install ]] && mkdir /etc/VPS-MX/Slow/install
  [[ ! -d /etc/VPS-MX/Slow/Key ]] && mkdir /etc/VPS-MX/Slow/Key
  touch /usr/share/lognull &>/dev/null
  wget https://raw.githubusercontent.com/thefather12/ADM-FATHER2/main/Otros/SPR -O /usr/bin/SPR &>/dev/null &>/dev/null
  chmod 775 /usr/bin/SPR &>/dev/null
  wget -O /bin/rebootnb https://raw.githubusercontent.com/thefather12/ADM-FATHER2/main/Otros/rebootnb &>/dev/null
  chmod +x /bin/rebootnb
  wget -O /bin/resetsshdrop https://raw.githubusercontent.com/thefather12/ADM-FATHER2/main/Otros/resetsshdrop &>/dev/null
  chmod +x /bin/resetsshdrop
  wget -O /etc/versin_script_new https://raw.githubusercontent.com/NetVPS/Multi-Script/main/LACASITAMX-v9x/Otros/Version &>/dev/null
  wget -O /etc/ssh/sshd_config https://raw.githubusercontent.com/thefather12/ADM-FATHER2/main/Otros/sshd &>/dev/null
  chmod 777 /etc/ssh/sshd_config
  wget -O /usr/bin/trans https://raw.githubusercontent.com/thefather12/ADM-FATHER2/main/Otros/trans &>/dev/null
  wget -O /bin/Desbloqueo.sh https://raw.githubusercontent.com/thefather12/ADM-FATHER2/main/Otros/desbloqueo.sh &>/dev/null
  chmod +x /bin/Desbloqueo.sh
  wget -O /bin/monitor.sh https://raw.githubusercontent.com/thefather12/ADM-FATHER2/main/Otros/monitor.sh &>/dev/null
  chmod +x /bin/monitor.sh
  wget -O /var/www/html/estilos.css https://raw.githubusercontent.com/thefather12/ADM-FATHER2/main/Otros/estilos.css &>/dev/null
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
  wget -O /etc/versin_script_new https://raw.githubusercontent.com/thefather12/ADM-FATHER2/main/Otros/Version &>/dev/null
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
  echo 'figlet -f slant "LACASITA" |lolcat' >>.bashrc
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
    #[[ $(ps x | grep "bot_plus" | grep -v grep | wc -l) != '0' ]] && wget -qO- https://raw.githubusercontent.com/carecagm/main/Install/ShellBot.sh >/etc/SSHPlus/ShellBot.sh
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
  rm -rf VPS-MX.sh
  rm -rf lista-arq
  service ssh restart &>/dev/null
  clear && clear
  msgi -bar2
  echo -e "\e[1;92m             >> INSTALACION COMPLETADA <<" && msgi -bar2
  echo -e "      COMANDO PRINCIPAL PARA ENTRAR AL PANEL "
  echo -e "                      \033[1;41m  menu  \033[0;37m" && msgi -bar2

}

# --- FIN DE LAS FUNCIONES ---

# --- INICIO DEL INSTALADOR SIMPLIFICADO ---

# Si el script se llama sin argumentos (uso normal), ejecuta la instalación completa.
if [ $# -eq 0 ] || [ "$1" = "-s" ] || [ "$1" = "--start" ]; then
    install_inicial # Configuraciones iniciales (IP, root pass, repositorios)
    install_paquetes # Instalación de dependencias (Apache, curl, etc.)
    install_LACASITA_90 # Instalación del script La Casita
elif [ "$1" = "-c" ] || [ "$1" = "--continue" ]; then
    install_paquetes # Solo instala paquetes si se llama con -c (para continuar después de un fallo)
    install_LACASITA_90
fi

exit
