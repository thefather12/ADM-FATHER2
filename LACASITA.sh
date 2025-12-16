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
  "-bar2"|"-bar")cor="${VERDE}====================================================${SEMCOR}" && echo -e "${cor}";;
 esac
}
os_system() {
system=$(cat -n /etc/issue |grep 1 |cut -d ' ' -f6,7,8 |sed 's/1//' |sed 's/      //' |sed 's/ //')
distro=$(cat -n /etc/issue |grep 1 |cut -d ' ' -f1,2,3,4,5 |sed 's/1//' |sed 's/      //' |sed 's/ //')
case $distro in
"Arch Linux")
  apt-get install figlet -y
  [[ $(dpkg --get-selections|grep -w "figlet"|head -1) ]] || apt-get install figlet -y
  figlet -f big ADM-FATHER | lolcat
;;
"Kali GNU/Linux")
  apt-get install figlet -y
  [[ $(dpkg --get-selections|grep -w "figlet"|head -1) ]] || apt-get install figlet -y
  figlet -f big ADM-FATHER | lolcat
;;
"Ubuntu 18.04 LTS")
  apt-get install figlet -y
  [[ $(dpkg --get-selections|grep -w "figlet"|head -1) ]] || apt-get install figlet -y
  figlet -f big ADM-FATHER | lolcat
;;
"Ubuntu 20.04 LTS")
  apt-get install figlet -y
  [[ $(dpkg --get-selections|grep -w "figlet"|head -1) ]] || apt-get install figlet -y
  figlet -f big ADM-FATHER | lolcat
;;
"Ubuntu 22.04 LTS")
  apt-get install figlet -y
  [[ $(dpkg --get-selections|grep -w "figlet"|head -1) ]] || apt-get install figlet -y
  figlet -f big ADM-FATHER | lolcat
;;
"Debian GNU/Linux 10")
  apt-get install figlet -y
  [[ $(dpkg --get-selections|grep -w "figlet"|head -1) ]] || apt-get install figlet -y
  figlet -f big ADM-FATHER | lolcat
;;
"Debian GNU/Linux 11")
  apt-get install figlet -y
  [[ $(dpkg --get-selections|grep -w "figlet"|head -1) ]] || apt-get install figlet -y
  figlet -f big ADM-FATHER | lolcat
;;
"Debian GNU/Linux 12")
  apt-get install figlet -y
  [[ $(dpkg --get-selections|grep -w "figlet"|head -1) ]] || apt-get install figlet -y
  figlet -f big ADM-FATHER | lolcat
;;
esac
vercion=$(printf '%s' "$distro"|cut -d '.' -f1)
case $distro in
"Debian GNU/Linux 8") vercion="jessie";;
"Debian GNU/Linux 9") vercion="stretch";;
"Debian GNU/Linux 10") vercion="buster";;
"Debian GNU/Linux 11") vercion="bullseye";;
"Debian GNU/Linux 12") vercion="Bookworm";;
esac
}
install_dependencies() {
clear
msg -bar2
msg -ama "  [✔] INSTALANDO DEPENDENCIAS"
msg -bar2
clear
os_system
case $distro in
"Kali GNU/Linux")
    apt update -y
    apt install curl -y
    apt install python -y
    apt install python3 -y
    apt install netcat -y
    apt install netcat-openbsd -y
    apt install netcat-traditional -y
    apt install figlet -y
    apt install perl -y
    apt install openssl -y
    apt install grep -y
    apt install python3-pip -y
    apt install screen -y
    apt install nano -y
    apt install bc -y
    apt install nmap -y
    apt install apache2 -y
    apt install oneko -y
    apt install zip -y
    apt install unzip -y
    apt install subversion -y
    apt install vnstat -y
    apt install cron -y
    apt install lsof -y
    apt install less -y
    apt install ufw -y
    apt install ruby -y
    apt install nodejs -y
    apt install pv -y
    apt install bash-completion -y
    apt install rsyslog -y
    apt install dropbear -y
    apt install dnsutils -y
    apt install openssh-server -y
    apt install cdbs -y
    apt install libpam-cracklib -y
    apt install lolcat -y
    apt install at -y
    apt install make -y
    apt install gcc -y
    apt install libncurses5-dev -y
    apt install cmake -y
    apt install libssl-dev -y
    apt install zlib1g-dev -y
    apt install libpcre3-dev -y
    apt install libexpat1-dev -y
    apt install libxml-parser-perl -y
    apt install libxml2-dev -y
    apt install libxslt1-dev -y
    apt install git -y
;;
*)
apt-get update -y
apt-get install curl -y
apt-get install python -y
apt-get install python3 -y
apt-get install netcat -y
apt-get install netcat-openbsd -y
apt-get install netcat-traditional -y
apt-get install figlet -y
apt-get install perl -y
apt-get install openssl -y
apt-get install grep -y
apt-get install python3-pip -y
apt-get install screen -y
apt-get install nano -y
apt-get install bc -y
apt-get install nmap -y
apt-get install apache2 -y
apt-get install oneko -y
apt-get install zip -y
apt-get install unzip -y
apt-get install subversion -y
apt-get install vnstat -y
apt-get install cron -y
apt-get install lsof -y
apt-get install less -y
apt-get install ufw -y
apt-get install ruby -y
apt-get install nodejs -y
apt-get install pv -y
apt-get install bash-completion -y
apt-get install rsyslog -y
apt-get install dropbear -y
apt-get install dnsutils -y
apt-get install openssh-server -y
apt-get install cdbs -y
apt-get install libpam-cracklib -y
    apt-get install lolcat -y
    apt-get install at -y
    apt-get install make -y
    apt-get install gcc -y
    apt-get install libncurses5-dev -y
    apt-get install cmake -y
    apt-get install libssl-dev -y
    apt-get install zlib1g-dev -y
    apt-get install libpcre3-dev -y
    apt-get install libexpat1-dev -y
    apt-get install libxml-parser-perl -y
    apt-get install libxml2-dev -y
    apt-get install libxslt1-dev -y
    apt-get install git -y
    ;;
esac
msg -bar2
}

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
    SCPdir="/etc/VPS-MX" # Definimos SCPdir
    mkdir -p ${SCPdir} >/dev/null 2>&1 # Aseguramos que el directorio exista
    
    # -----------------------------------------------------
    # REEMPLAZO DE WGET Y TAR.GZ POR GIT CLONE
    # -----------------------------------------------------

    # 1. Instalar Git si no está presente
    if ! command -v git &>/dev/null; then
        msg -ama "Instalando Git..."
        apt install git -y >/dev/null 2>&1
    fi

    # 2. Definir la URL del Repositorio
    URL_REPO_GIT="https://github.com/thefather12/ADM-FATHER2.git" 
    
    msg -azu "Clonando archivos desde el repositorio Git: ${URL_REPO_GIT}"
    
    # 3. Clonar o Actualizar (BLOQUE CORREGIDO y ROBUSTO)
    cd ${SCPdir}
    
    if [ -d "${SCPdir}/.git" ]; then
        # Si ya existe, intentar solo actualizar (pull)
        msg -azu "Intentando actualizar el repositorio existente..."
        git reset --hard >/dev/null 2>&1
        git pull $URL_REPO_GIT >/dev/null 2>&1
        if [ $? -eq 0 ]; then
             msg -verde "Archivos actualizados con Git."
        else
             msg -verm "ADVERTENCIA: Falló la actualización (git pull). Revise la conexión."
        fi
    else
        # Si no existe, clonar por primera vez
        if [ -d "/tmp/git_temp_clone" ]; then rm -rf /tmp/git_temp_clone; fi # Limpieza
        
        git clone $URL_REPO_GIT /tmp/git_temp_clone &>/dev/null
        
        if [ $? -eq 0 ] && [ -d "/tmp/git_temp_clone" ]; then
            # Clonación exitosa, movemos el contenido usando rsync para mayor seguridad
            # rsync -a copia el contenido y permisos, evitando el error de mv
            rsync -a /tmp/git_temp_clone/ ${SCPdir}/
            
            # Luego movemos la carpeta .git para que quede en SCPdir
            mv /tmp/git_temp_clone/.git ${SCPdir}/
            
            rm -rf /tmp/git_temp_clone
            msg -verde "Archivos clonados con Git en ${SCPdir}."
        else
            msg -verm "ERROR FATAL: No se pudo clonar el repositorio Git."
            msg -verm "Verifique la conexión a Internet o la URL: ${URL_REPO_GIT}"
            exit 1
        fi
    fi

    # -----------------------------------------------------
    # CONTINUACIÓN DEL SCRIPT ORIGINAL
    # -----------------------------------------------------
    
    cd /etc
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
    
    cd
    
    # Instalación de herramientas auxiliares y configuraciones (manteniendo las URLs originales del script con Key)
    [[ ! -d /etc/VPS-MX/v2ray ]] && mkdir /etc/VPS-MX/v2ray
    [[ ! -d /etc/VPS-MX/Slow ]] && mkdir /etc/VPS-MX/Slow
    [[ ! -d /etc/VPS-MX/Slow/install ]] && mkdir /etc/VPS-MX/Slow/install
    [[ ! -d /etc/VPS-MX/Slow/Key ]] && mkdir /etc/VPS-MX/Slow/Key
    touch /usr/share/lognull &>/dev/null

    # Se mantiene la descarga de utilidades clave (que NO son parte del repositorio)
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

install_dependencies
install_core_lacasita

