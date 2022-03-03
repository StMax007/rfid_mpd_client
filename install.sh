echo -e "device_tree_param=spi=on\ndtoverlay=spi-bcm2708" >> /boot/config.txt 	#SPI aktivieren


pacman --noconfirm -Syu git base-devel python-pip			# GIT für Installationspakete benötigt, base-devel wird für gcc-Compiler benötigt

# reboot
git clone https://github.com/lthiery/SPI-Py.git
git clone https://github.com/pimylifeup/MFRC522-python.git

cd SPI-Py
python setup.py install
cd ..

cd MFRC522-python
python setup.py install
cd ..


pip install python-mpd2


cat <<EOF > /etc/systemd/system/rfid_player.service
[Unit]
Description=Blah Blubb

[Service]
ExecStart=/usr/bin/python3 /root/rfid_player.py

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload # lade service-dateien neu

systemctl enable --now rfid_player.service

reboot






