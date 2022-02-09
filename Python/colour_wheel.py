import time

RED = (255, 0, 0)
YELLOW = (255, 150, 0)
GREEN = (0, 255, 0)
CYAN = (0, 255, 255)
BLUE = (0, 0, 255)
PURPLE = (180, 0, 255)
WHITE = (255, 255, 255)
OFF = (0, 0, 0)

print("Colours importet!")
COLOR_LIST = [RED, YELLOW, GREEN, CYAN, BLUE, PURPLE, WHITE, OFF]

def wheel(pos):
    # Input a value 0 to 255 to get a color value.
    # The colours are a transition r - g - b - back to r.
    if pos < 0 or pos > 255:
        return (0, 0, 0)
    if pos < 85:
        return (255 - pos * 3, pos * 3, 0)
    if pos < 170:
        pos -= 85
        return (0, 255 - pos * 3, pos * 3)
    pos -= 170
    return (pos * 3, 0, 255 - pos * 3)

def show_color(pixels, color, n = 9):
    for i in range(n):
        pixels[i] = color
        pixels.write()

def color_chase(pixels, color, wait, n = 9):
    for i in range(n):
        pixels[i] = color
        time.sleep(wait)
        pixels.write()
    

def color_chase_full(pixels, color, wait, n = 9):
    for i in range(n):
        pixels[i] = color
        pixels.write()

    for i in range(n):
        time.sleep(wait)
        pixels[i] = OFF
        pixels.write()
    
    
def color_chase_half(pixels, color, wait, n = 9):
    for i in range(n):
        pixels[i] = color
        pixels.write()

    for i in range(n/2):
        time.sleep(wait*2)
        pixels[i] = OFF
        pixels[n-i-1] = OFF
        pixels.write()
        

def rainbow_cycle(pixels, wait, n = 9):
    for j in range(255):
        for i in range(n):
            rc_index = (i * 256 // n) + j * 5
            pixels[i] = wheel(rc_index & 255)
        pixels.write()
        time.sleep(wait)
        


def rainbow(pixels, n = 9):
    for j in range(255):
        for i in range(n):
            idx = int(i + j)
            pixels[i] = wheel(idx & 255)
        pixels.write()
        
def clear(pixels, n = 9):
  for i in range(n):
    pixels[i] = (0, 0, 0)
    pixels.write()
        