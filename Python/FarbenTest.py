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

colour_wheel.show_color(neopix, (0,200,100))