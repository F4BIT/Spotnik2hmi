#!/bin/bash
whiptail --title "INFORMATION:" --msgbox "Ce script considere que vous partez d une image disponible par F5NLG du Spotnik 1.9 et fonctionnelle sur Raspberry ou Orange Pi. Il permet d ajouter un ecran Nextion a la distribution. Plus d informations sur http://blog.f8asb.com/spotnik2hmi.                                                                                         Team F0DEI/F5SWB/F8ASB" 15 60


#!/bin/bash
INSTALL=$(whiptail --title "Choisir votre installation" --radiolist \
"Que voulez vous installer?" 15 60 4 \
"SPOTNIK2HMI" "Gestion Nextion avec Spotnik " ON \
"NEXTION" "Programmation ecran Nextion " OFF 3>&1 1>&2 2>&3)
 
exitstatus=$?

if [ $exitstatus = 0 ]; then
    echo "Installation de :" $INSTALL

else
    echo "Vous avez annulé"
fi

if [ $INSTALL = "SPOTNIK2HMI" ]; then

# MAJ
echo "UPGRADE IN PROGRESS..."
apt-get -y update
#apt-get -y dist-upgrade
apt-get -y upgrade
echo "UPGRADE COMPLETED !"
 
echo "INSTALLATION DEPENDANCE PYTHON"
install gcc python-dev python-setuptools
apt-get -y install python-pip
pip install requests
echo "INSTALLATION COMPLETE !"

echo "INSTALLATION scripts python"
git clone https://github.com/F8ASB/spotnik2hmi.git /opt/spotnik/spotnik2hmi/

chmod +x /opt/spotnik/spotnik2hmi/spotnik2hmi.py

echo "INSTALLATION COMPLETE !"

echo "INSTALLATION UTILITAIRE METAR"
git clone https://github.com/python-metar/python-metar.git /opt/spotnik/spotnik2hmi/python-metar/
echo "INSTALLATION COMPLETE !"

PORT=$(whiptail --title "Choix du Port de communication" --radiolist \
"Sur quoi raccorder vous le Nextion?" 15 60 4 \
"ttyAMA0" "Sur Raspberry Pi " ON \
"ttyS0" "Sur Orange Pi " OFF \
"ttyUSB0" "Orange Pi ou Raspberry Pi " OFF 3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ]; then

#Creation d'un service via systemd by F4BIT
echo "Creation d'un service SPOTNIK2HMI via systemd"

systemctl stop spotnik2hmi.service
systemctl disable spotnik2hmi.service
rm /lib/systemd/system/spotnik2hmi.service
sleep 1
echo "[Unit]" >> /lib/systemd/system/spotnik2hmi.service
echo "Description=Spotnik2hmi" >> /lib/systemd/system/spotnik2hmi.service
echo "After=multi-user.target" >> /lib/systemd/system/spotnik2hmi.service
echo "" >> /lib/systemd/system/spotnik2hmi.service
echo "[Service]" >> /lib/systemd/system/spotnik2hmi.service
echo "Type=simple" >> /lib/systemd/system/spotnik2hmi.service
echo "ExecStart=/usr/bin/python /opt/spotnik/spotnik2hmi/spotnik2hmi.py $PORT 9600" >> /lib/systemd/system/spotnik2hmi.service
echo "Restart=on-abort" >> /lib/systemd/system/spotnik2hmi.service
echo "" >> /lib/systemd/system/spotnik2hmi.service
echo "[Install]" >> /lib/systemd/system/spotnik2hmi.service
echo "WantedBy=multi-user.target" >> /lib/systemd/system/spotnik2hmi.service
chmod 644 /lib/systemd/system/spotnik2hmi.service
systemctl daemon-reload
systemctl enable spotnik2hmi.service
systemctl start spotnik2hmi.service
echo "Service SPOTNIK2HMI actif"
############

else
    echo "Vous avez annulé"
fi
exit

else

PORT=$(whiptail --title "Choix du Port de communication" --radiolist \
"Sur quoi raccorder vous le Nextion?" 15 60 4 \
"ttyAMA0" "Sur Raspberry Pi " ON \
"ttyS0" "Sur Orange Pi " OFF \
"ttyUSB0" "Orange Pi ou Raspberry Pi " OFF 3>&1 1>&2 2>&3)
 
exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "Port du Nextion :" $PORT
else
    echo "Vous avez annule"
fi

ECRAN=$(whiptail --title "Choix type d'ecran NEXTION" --radiolist \
"Quel Type d'ecran ?" 15 60 4 \
"NX3224K024.tft" "Ecran 2,4 Enhanced" OFF \
"NX3224T024.tft" "Ecran 2,4 Basic" OFF \
"NX3224K028.tft" "Ecran 2,8 Enhanced" OFF \
"NX3224T028.tft" "Ecran 2,8 Basic" OFF \
"NX4024K032.tft" "Ecran 3,2 Enhanced" OFF \
"NX4024T032.tft" "Ecran 3,2 Basic" OFF \
"NX4832K035.tft" "Ecran 3,5 Enhanced" OFF \
"NX4832T035.tft" "Ecran 3,5 Basic" ON \
"NX8048K050.tft" "Ecran 5,0 Enhanced" OFF \
"NX8048T050.tft" "Ecran 5,0 Basic" OFF \
"NX8048K070.tft" "Ecran 7,0 Enhanced" OFF \
"NX8048T070.tft" "Ecran 7,0 Basic" OFF 3>&1 1>&2 2>&3)
 
exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "Type d'écran :" $ECRAN
python /opt/spotnik/spotnik2hmi/nextion/nextion.py '/opt/spotnik/spotnik2hmi/nextion/'$ECRAN '/dev/'$PORT

else
    echo "Vous avez annule"
fi
fi


echo ""
echo "INSTALL TERMINEE AVEC SUCCES"
echo ""
echo " ENJOY ;) TEAM:F0DEI,F5SWB,F8ASB"
echo ""

