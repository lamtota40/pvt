# ==========================================
# Getting
#!/bin/bash
# SL
# ==========================================
# Color
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'
# ==========================================
# Getting
MYIP=$(wget -qO- ipinfo.io/ip);
echo "Checking VPS"

#IZIN=$( curl http://akses.jagoanneon-premium.xyz:81/akses | grep $MYIP )

IZIN=$( curl https://raw.githubusercontent.com/godtrex99/ip/main/ipvps | grep $MYIP )

if [ $MYIP = $IZIN ]; then
echo -e "${GREEN}Akses Di Izinkan...${NC}"
else
echo -e "${RED}VPS tidak diijinkan${NC}";
echo "Kontak Admin Untuk Mendapatkan Akses Script"
echo "Facebook   : Generasi Ronggolawe Tuban"
echo "WhatsApp   : 083857684916"
exit 0
fi
clear
NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/etc/xray/fb-vmessgrpc.json")
	if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
		clear
		echo ""
		echo "You have no existing clients!"
		exit 1
	fi

	clear
	echo ""
	echo "Select the existing client you want to renew"
	echo " Press CTRL+C to return"
	echo -e "==============================="
	grep -E "^### " "/etc/xray/fb-vmessgrpc.json" | cut -d ' ' -f 2-3 | nl -s ') '
	until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
		if [[ ${CLIENT_NUMBER} == '1' ]]; then
			read -rp "Select one client [1]: " CLIENT_NUMBER
		else
			read -rp "Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
		fi
	done
read -p "Expired (Days): " masaaktif
user=$(grep -E "^### " "/etc/xray/fb-vmessgrpc.json" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^### " "/etc/xray/fb-vmessgrpc.json" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)
user=$(grep -E "^### " "/etc/xray/fb-vlessgrpc.json" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^### " "/etc/xray/fb-vlessgrpc.json" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)
now=$(date +%Y-%m-%d)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
exp3=$(($exp2 + $masaaktif))
exp4=`date -d "$exp3 days" +"%Y-%m-%d"`
sed -i "s/### $user $exp/### $user $exp4/g" /etc/xray/fb-vmessgrpc.json
sed -i "s/### $user $exp/### $user $exp4/g" /etc/xray/fb-vlessgrpc.json
systemctl restart fb-vmess-grpc.service
systemctl restart fb-vless-grpc.service
service cron restart
clear
echo ""
echo -e "══════════════════════" | lolcat
echo "  XRAY Vmess/Vless gRPC Account Renewed  "
echo -e "══════════════════════" | lolcat
echo " Username  : $user"
echo " Expired   : $exp4"
echo -e "══════════════════════" | lolcat
echo -e "${RED}AutoScriptSSH By Ronggolawe${NC}"
echo -e "══════════════════════" | lolcat
echo -e""
read -p "Ketik Enter Untuk Kembali Ke Menu...."
sleep 1
menu
exit 0
fi
