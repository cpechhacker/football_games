## Connect Neopixel to Pin 4 and Touch to Pin 14
import network
import esp32
from esp import espnow
import time
from machine import Pin

import random
import struct
import time
from machine import deepsleep
from ulab import numpy as np

import machine, neopixel
from machine import TouchPad, Pin
import colour_wheel

AnzahlPixel = 10
NeoPixelPin = 4
TouchPin = 14
TouchSensibility = 2 ## set to 2 for ball detection set lower to be more sensible  ## default = 3.5
WakeUpPin = 12

neopix = neopixel.NeoPixel(machine.Pin(NeoPixelPin), AnzahlPixel)
colour_wheel.clear(neopix, AnzahlPixel)

## Wake up from DeepSleep
start_time = time.time()
wake1 = Pin(WakeUpPin, mode = Pin.IN)
esp32.wake_on_ext0(pin = wake1, level = esp32.WAKEUP_ANY_HIGH) ## #level parameter can be: esp32.WAKEUP_ANY_HIGH or esp32.WAKEUP_ALL_LOW
print("I'm awake")

# A WLAN interface must be active to send()/recv()
w0 = network.WLAN(network.STA_IF)
w0.active(True)

w0.config('mac') ## See mac adress from device


def recv_cb(e):
    host, msg = e.irecv()
    global wait_for_event
    wait_for_event = True
    
    global event_list
    event_list =  msg
    

e = espnow.ESPNow()
e.init()
e.config(on_recv=recv_cb)

peer_list = [b'0\xae\xa4\xd3\xa3\xe8'] # mac adress ## b'X\xbf%\x9d\x8c\x94'
for peer in peer_list:
    e.add_peer(peer)

led = Pin(22, Pin.OUT)
led.value(True)




def process_rx(event_list, FUN = colour_wheel.show_color):
    
    ## TO DO: Wait is not defnied in every function
    # FUN(neopix, (event_list[0],event_list[1],event_list[2]), wait = event_list[3] / AnzahlPixel, n = AnzahlPixel) ## wit is not defined for show
    
    ## GAME 1: 
    FUN(neopix, (event_list[0],event_list[1],event_list[2]), n = AnzahlPixel)
    
    ## GAME 2: Countdown (not working becuase of no interrupt)
    ## colour_wheel.color_chase_half(neopix, (event_list[0],event_list[1],event_list[2]), wait = event_list[3] / AnzahlPixel, n = AnzahlPixel)


def detect_event(value, Array, Outlier_Value = 3.5): 
    ArrayMean = np.mean(Array)
    ArraySt   = np.std(Array) + 0.5
    Grenze = ArrayMean - Outlier_Value * ArraySt
    EventDetector = value < Grenze
        
    return(EventDetector)


def process_event(SleepTime = 0.3):
    print("Event detected!")
    colour_wheel.clear(neopix, n = AnzahlPixel)
    time.sleep(SleepTime)
    
    e.send(bytearray([1]))
    print("Bytes sent per ESP - NOW!")
    print("Event processed!")


def demo():    
    touch = TouchPad(Pin(TouchPin))
    
    NSamples = 20
    Array = [touch.read()] * NSamples
    Array = np.array(Array)
    i = 0
    last_event = time.time()    
        
    global wait_for_event
    wait_for_event = False
    
    global event_list
    event_list = []
    

    while True:
            try:
                value = touch.read()
            except Exception as e:
                print('Konnte Touch Werte nicht auslesen'.format(type(e).__name__, e))
            

            Array[ i % NSamples] = value
            event_detect = detect_event(value, Array, Outlier_Value = TouchSensibility)            
            
            if event_detect:                
                last_event = time.time()
                process_event()
                print("Last Event: " + str(last_event))

            if wait_for_event:
                print("Got following bytes per ESP - NOW:")
                print(event_list)
                
                led.value(False)
                process_rx(event_list)                
                time.sleep(0.3)
                led.value(True)
                wait_for_event = False
            
            ## gehe zu DeepSleep falls 10 Minuten kein Event passiert oder 30 Minuten nach Start
            #if time.time() - last_event > 10 * 60 or time.time() - start_time > 30 * 60: 
            #    print("Going to Deepsleep!")
            #    colour_wheel.clear(neopix, AnzahlPixel)
            #    deepsleep()
            
            i += 1
            
            


if __name__ == "__main__":
    print("Startet!")
    demo()


