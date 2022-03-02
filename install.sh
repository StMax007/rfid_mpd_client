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


cat <<EOF > /root/rfid_player.py
import time
from mpd import MPDClient

while True:
    try:
        client = MPDClient()               # create client object
        client.timeout = 10                # network timeout in seconds (floats allowed), default: None
        client.idletimeout = None          # timeout for fetching the result of the idle command is handled seperately, default: None
        client.connect("localhost", 6600) # client.connect("raudio.local", 6600)  # connect to localhost:6600
        print(client.mpd_version)          # print the MPD version

        client.stop()
        client.clear()  # alle Songs aus Playlist werden gelöscht
        #client.add("USB/LICENSE_KEY/Rap/Bite Me - NEFFEX.mp3")
        client.findadd('album', 'Album1')
        client.play()

        time.sleep(5)

        client.stop()
        client.clear()
        client.findadd('album', 'Album2')
        client.play()

        client.disconnect()
    except:
        time.sleep(5)
        pass
EOF


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






