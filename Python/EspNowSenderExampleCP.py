import network
from esp import espnow
import time

# A WLAN interface must be active to send()/recv()
w0 = network.WLAN(network.STA_IF)  # Or network.AP_IF
w0.active(True)

w0.config('mac') ## my mac adress

e = espnow.ESPNow()
e.init()

peer_list = [b'X\xbf%\x9d\x8c\x94', b'0\xae\xa4\xd3\xa3\xe8']
for peer in peer_list:
    e.add_peer(peer)

#peer = b'0\xae\xa4\xd3\xa3\xe8'  # MAC address of peer's wifi interface
#e.add_peer(peer)

e.send("Starting...")       # Send to all peers
for i in range(100):
    e.send(peer, str(i)*20, True)
    time.sleep(0.5)
e.send(b'end')

