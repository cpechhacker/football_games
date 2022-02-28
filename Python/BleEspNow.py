import bluetooth
import random
import struct
import time
from ulab import numpy as np
import random
import network
from esp import espnow
import time
from BlePeripherical import BLESimplePeripheral

# A WLAN interface must be active to send()/recv()
w0 = network.WLAN(network.STA_IF)  # Or network.AP_IF
w0.active(True)

w0.config('mac') ## my mac adress

ble_msg = ""

def recv_cb(e):
    host, msg = e.irecv()
    global event_detected
    event_detected = True
    

e = espnow.ESPNow()
e.init()
e.config(on_recv=recv_cb)

# Set Peers:   ## Pico Kit D4             Lolin32-1                 Lolin32-2             Lolin32-3          Lolin32-4           Lolin32-5
peer_list = [b'\xd8\xa0\x1d]\xc7\x08', b'X\xbf%\x9d\x8c\x94', b'X\xbf%\x9d\x8a\xa8', b'X\xbf%6\xbc\xdc', b'X\xbf%6\xb98', b'X\xbf%\x9d\x8cT']   


def connect_peers(peer_list):
    peers_available     = []
    for peer in peer_list:
        e.add_peer(peer)
        msg = e.send(peer, bytearray([1]))
        if msg:
          peers_available.append(peer)
    return peers_available
    
peers_available = connect_peers(peer_list)
    
    


def demo():
    ble = bluetooth.BLE()
    p = BLESimplePeripheral(ble)
        
    global wait_for_event
    wait_for_event = False
    
    global event_detected
    event_detected = False
        
    global event_list
    event_list = []
        
    def on_rx(v):
        print("BLE Bytes received:", v)

        global wait_for_event
        wait_for_event = True
        
        global event_list
        event_list =  v 
                
    p.on_write(on_rx)


    while True:
        if p.is_connected():
                                                    
            if wait_for_event:
                print("Send following bytes per ESP - NOW")
                print(event_list)
                #e.send(event_list)  ## send event list to all peers
                
                try:
                  peer_receiver = peers_available[event_list[4]]
                  print("Send to following peer:" + str(peer_receiver))
                  e.send(peer_receiver, event_list) ## send to one special peer
                except:
                  print("An exception occurred. Es konnte kein Peer gefunden werden")                                    
                
                wait_for_event = False
            
            if event_detected:
                print("Got bytes per ESP - NOW")
                print("Send bytes to BLE device")
                p.send(bytearray([1, len(peers_available)]))
                event_detected = False
            


if __name__ == "__main__":
    print("Startet!")
    demo()



