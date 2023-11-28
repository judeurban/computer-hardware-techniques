# filename: RS-232.py

import time
from typing import List

BUFFER_SIZE_BYTES = 1
BITS_IN_BYTES = 8
incoming_buffer: List[int] = [0] * BITS_IN_BYTES
outgoing_buffer: List[int] = [0] * BITS_IN_BYTES

NUM_START_BITS = 1
NUM_END_BITS = 2
BAUD_RATE_BPS = 3600
BAUD_PERIOD_S = 1 / BAUD_RATE_BPS

def read_switch_buttons() -> List[int]: ...
def push_button_is_pressed() -> bool: ...

def set_pin(pin_name: str, set_value: bool | int) -> None:
    return

def get_pin(pin_name: str) -> bool:
    return False
#   return pin_name.value

def send_transmission():

    num_ones = 0

    # get the data from the Cyclone V switch buttons
    outgoing_buffer = read_switch_buttons()

    # indicate to the receiver that we're about to send something
    set_pin('rts', 1)

    # verify that the receiver has received our message
    # don't wait forever

    timeout_s = 5
    start_time = time.time()
    while get_pin('cts') == 0:
        
        current_time = time.time()
        if current_time > start_time + timeout_s:
            break

    # send a transmission
    # this includes the starting bit, ending bits, and parity bit

    # send the starting bit sequence
    for i in range(NUM_START_BITS):
        set_pin('tx', 1)
        time.sleep(BAUD_PERIOD_S)

    # send the 
    for bit in outgoing_buffer:

        set_pin('tx', bit)
        time.sleep(BAUD_PERIOD_S)

        if bit == 1:
            num_ones += 1

    # two stop bits
    for i in range(NUM_END_BITS):
        set_pin('tx', 0)
        time.sleep(BAUD_PERIOD_S)

    # send a parity bit
    parity_bit = num_ones % 0
    set_pin('tx', parity_bit)
    time.sleep(BAUD_PERIOD_S)

    # end transmission
    set_pin('tx', 0)

def receive_transmission():
    
    num_ones = 0

    # indicate to the sender that we are listening
    set_pin('cts', 1)

    # wait for the first starting bit
    while get_pin('rx') == 0:
        pass

    # the first bit has arrived. wait exactly half the baud period
    # this will give of 180deg phase (sampling halfway thru the transmission)
    time.sleep(BAUD_PERIOD_S / 2)

    for i in range(NUM_START_BITS):
        
        read_bit = get_pin('rx')
        time.sleep(BAUD_PERIOD_S)
        
        if read_bit == 1: num_ones += 1

    # wait for all starting bits
    # the first sample should be delayed a half period.
    # The remaining samples should be exactly one period apart.

    for i in range(8):
        
        read_bit = get_pin('rx')
        time.sleep(BAUD_PERIOD_S)
        
        if read_bit == 1: num_ones += 1
            
        
    # read the two stop bits
    for i in range(NUM_END_BITS):
        read_bit = get_pin('rx')
        time.sleep(BAUD_PERIOD_S)
        
        if read_bit == 1: num_ones += 1
    
    parity_bit = get_pin('rx')
    
    if num_ones % 2 != parity_bit:
        raise RuntimeError("Could not receive from the sender.")

    # indicate to the sender that we're terminating the transmission
    set_pin('cts', 0)

def main():

    # two options
    # 1. user presses button (send)
    # 2. we get a RTS signal (receive)

    while True:

        # transmit information
        if push_button_is_pressed():
            send_transmission()

        # listen for information if the RTS pin is high
        if get_pin('rts'):
            receive_transmission()

    # update 7-seg displays
    # update_displays(incoming_buffer)
