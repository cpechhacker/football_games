## Connect Neopixel to Pin 4 and Touch to Pin 14

import bluetooth
import random
import struct
import time
from ulab import numpy as np
import random

import machine, neopixel
from machine import TouchPad, Pin
import colour_wheel
import time
from BlePeripherical import BLESimplePeripheral

AnzahlPixel = 10
NeoPixelPin = 4
TouchPin = 14
TouchSensibility = 1.5 ## set lower to be more sensible  ## default = 3.5

neopix = neopixel.NeoPixel(machine.Pin(NeoPixelPin), AnzahlPixel)

sensor_interval = 100

def process_rx(event_list, FUN = colour_wheel.show_color):
    
    ## TO DO: Wait is not defnied in every function
    # FUN(neopix, (event_list[0],event_list[1],event_list[2]), wait = event_list[3] / AnzahlPixel, n = AnzahlPixel) ## wit is not defined for show
    
    ## GAME 1:
    ## FUN(neopix, (event_list[0],event_list[1],event_list[2]), n = AnzahlPixel)
    
    ## GAME 2:
    colour_wheel.color_chase_full(neopix, (event_list[0],event_list[1],event_list[2]), wait = event_list[3] / AnzahlPixel, n = AnzahlPixel)


def detect_event(value, Array, Outlier_Value = 3.5, BlePeripheral = 0, SleepTime = 0.3): 
    ArrayMean = np.mean(Array)
    ArraySt   = np.std(Array) + 0.5
    Grenze = ArrayMean - Outlier_Value * ArraySt
    EventDetector = value < Grenze
    if EventDetector:
        print("Event detcted!")
        colour_wheel.clear(neopix, n =AnzahlPixel)
        time.sleep(SleepTime)
        if BlePeripheral != 0:
            BlePeripheral.send(bytearray([1]))
            print("Bytes sent!")
        print("Event processed!")
        
    return(EventDetector)

def demo():
    ble = bluetooth.BLE()
    p = BLESimplePeripheral(ble)
    
    touch = TouchPad(Pin(TouchPin))
    last_time = time.ticks_ms()
    
    global wait_for_event
    wait_for_event = False
    
    global event_list
    event_list = []
    
    def on_rx(v):
        print("RX received:", v)
        
        global wait_for_event
        wait_for_event = True
        print("Wait for Event" + str(wait_for_event))
        global event_list
        event_list =  v 

                
    p.on_write(on_rx)


    while True:
        if p.is_connected():
                

            
            try:
                value = touch.read()
            except Exception as e:
                print('Konnte Touch Werte nicht auslesen'.format(type(e).__name__, e))
            
            ## Send Ulab array
            if time.ticks_ms() - last_time > sensor_interval:
                last_time = time.ticks_ms()
                data = np.array([value, value, random.randint(3,8)])
                #print("Lese Werte aus!")                
                #print(data)
                p.send(data)
            
            #Array[ i % NSamples] = value
            #event_detect = detect_event(value, Array, Outlier_Value = TouchSensibility, BlePeripheral = p, SleepTime = 0.2)            
            

            if wait_for_event:
                print("Processing RX")
                process_rx(event_list)
                wait_for_event = False
            



if __name__ == "__main__":
    print("Startet!")
    demo()


