import time
from mpd import MPDClient
from mfrc522 import SimpleMFRC522


reader = SimpleMFRC522()

while True:
    try: 
        id, album_text = reader.read()

        album_text = str(id)

        #print(album_text)

        client = MPDClient()               # create client object
        client.timeout = 10                # network timeout in seconds (floats allowed), default: None
        client.idletimeout = None          # timeout for fetching the result of the idle command is handled seperately, default: None
        client.connect("localhost", 6600)  # client.connect("raudio.local", 6600)  # connect to localhost:6600


        client.stop()   # stop current playback
        client.clear()  # clear all spngs from playlist
        client.findadd('album', album_text) # add songs from selected album to the playlist
        client.play()   # start playing

        client.disconnect()
    except:
        pass

    time.sleep(1)