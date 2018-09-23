#!/usr/bin/env python3
import sys
import time
from socket import *

if len(sys.argv) != 3:
    print("Please enter IP address of server and Port\n")
    sys.exit()

#get the address of the input, tuple
address = (sys.argv[1],int(sys.argv[2]))

#create the socket and connect
#server-server: AF_INET  protocal-UDP: SOCK_DGRAM

client = socket(AF_INET, SOCK_DGRAM)
#set timeout for ping
client.settimeout(1)
#connect, timeout probably used in connect
client.connect(address)

#start to send UDP packets
for i in range(10):

#set initial value
    sendtime = time.time()
    message = 'PING' + str(i+1) + str(sendtime) +'\r\n'
#send UDP packets
    client.sendto(b'message', address)

    try:
        data, receive_address = client.recvfrom(1024)
        receivetime = time.time()
        #rtt = receivetime - sendtime
        rtt = int((receivetime - sendtime)*1000)
        print(f"ping to {sys.argv[1]}, seq = {i+1}, rtt = {rtt} ms")
    except timeout:
        print(f"ping to {sys.argv[1]}, seq = {i+1}, time out")
