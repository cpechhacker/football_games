import network
from esp import espnow

# A WLAN interface must be active to send()/recv()
w0 = network.WLAN(network.STA_IF)
w0.active(True)

w0.config('mac') ## See mac adress from device

e = espnow.ESPNow()
e.init()
peer = b'\xd8\xa0\x1d]\xc7\x08' # MAC address
e.add_peer(peer)

print("Starte und warte auf Signal!")

while True:
    host, msg = e.irecv()     # Available on ESP32 and ESP8266
    if msg:             # msg == None if timeout in irecv()
        print(host, msg)
        if msg == b'end':
            break