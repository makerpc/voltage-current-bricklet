#!/usr/bin/env python
# -*- coding: utf-8 -*-  

HOST = "localhost"
PORT = 4223
UID = "ABCD" # Change to your UID

from tinkerforge.ip_connection import IPConnection
from tinkerforge.bricklet_voltage_current import VoltageCurrent

# Callback function for current callback (parameter has unit mA)
def cb_current(current):
    print('Current: ' + str(current/1000.0) + ' A')

if __name__ == "__main__":
    ipcon = IPConnection(HOST, PORT) # Create ip connection to brickd

    vc = VoltageCurrent(UID) # Create device object
    ipcon.add_device(vc) # Add device to ip connection
    # Don't use device before it is added to a connection

    # Set Period for current callback to 1s (1000ms)
    # Note: The callback is only called every second if the 
    #       current has changed since the last call!
    vc.set_current_callback_period(1000)

    # Register current callback to function cb_current
    vc.register_callback(vc.CALLBACK_CURRENT, cb_current)

    raw_input('Press key to exit\n') # Use input() in Python 3
    ipcon.destroy()
