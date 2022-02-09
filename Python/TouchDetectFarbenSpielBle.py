## Connect Neopixel to Pin 4 and Touch to Pin 14
import esp32
import bluetooth
import random
import struct
import time
from machine import deepsleep
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
TouchSensibility = 2 ## set to 2 for ball detection set lower to be more sensible  ## default = 3.5
WakeUpPin = 12

neopix = neopixel.NeoPixel(machine.Pin(NeoPixelPin), AnzahlPixel)
colour_wheel.clear(neopix, AnzahlPixel)

## Wake up from DeepSleep
start_time = time.time()
wake1 = Pin(WakeUpPin, mode = Pin.IN)
esp32.wake_on_ext0(pin = wake1, level = esp32.WAKEUP_ANY_HIGH) ## #level parameter can be: esp32.WAKEUP_ANY_HIGH or esp32.WAKEUP_ALL_LOW
print("I'm awake")

def process_rx(event_list, FUN = colour_wheel.show_color):
    
    ## TO DO: Wait is not defnied in every function
    # FUN(neopix, (event_list[0],event_list[1],event_list[2]), wait = event_list[3] / AnzahlPixel, n = AnzahlPixel) ## wit is not defined for show
    
    ## GAME 1: 
    FUN(neopix, (event_list[0],event_list[1],event_list[2]), n = AnzahlPixel)
    
    ## GAME 2: Countdown (not working becuase of no interrupt)
    ## colour_wheel.color_chase_half(neopix, (event_list[0],event_list[1],event_list[2]), wait = event_list[3] / AnzahlPixel, n = AnzahlPixel)


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
    
    NSamples = 20
    Array = [touch.read()] * NSamples
    Array = np.array(Array)
    i = 0
    last_event = time.time()    
        
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
                
            ## TO DO: Send Ulab array                
            #data = ulab.array([3.8,8,11.4])
            #p.send(data)
            
            try:
                value = touch.read()
            except Exception as e:
                print('Konnte Touch Werte nicht auslesen'.format(type(e).__name__, e))
            
            # print(value)
            # time.sleep(0.01)
            Array[ i % NSamples] = value
            event_detect = detect_event(value, Array, Outlier_Value = TouchSensibility, BlePeripheral = p, SleepTime = 0.2)            
            
            if event_detect:
                last_event = time.time()
                print("Last Event" + str(last_event))

            if wait_for_event:
                print("Processing RX")
                process_rx(event_list)
                wait_for_event = False
            
            ## gehe zu DeepSleep falls 10 Minuten kein Event passiert oder 30 Minuten nach Start
            if time.time() - last_event > 10 * 60 or time.time() - start_time > 30 * 60: 
                print("Going to Deepsleep!")
                colour_wheel.clear(neopix, AnzahlPixel)
                deepsleep()
            
            i += 1
            
            


if __name__ == "__main__":
    print("Startet!")
    demo()

