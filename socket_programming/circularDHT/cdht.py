#!/usr/bin/env python3

import sys
from socket import *
import threading
import time

class Peer:
    def __init__(self, id, successor1, successor2):
        self.id = int(id)
        self.successor1 = int(successor1)
        self.successor2 = int(successor2)

    def pingUDP(self):
        #threading.Timer(5.0, self.pingUDP).start()
        #send ping to successors
        while True:
            new_socket = socket(AF_INET, SOCK_DGRAM)
            address1 = ('127.0.0.1', 50000+self.successor1)
            message1 = 'A ping request message was received from Peer '+ str(self.id)
            address2 = ('127.0.0.1', 50000+self.successor2)
            message2 = 'A ping request message was received from Peer '+ str(self.id)            
            #send ping
            new_socket.sendto(message1.encode(), address1)
            new_socket.sendto(message2.encode(), address2)
            #close the socket for sending ping
            new_socket.close()

            #create a new socket for receiver
            new_socket = socket(AF_INET, SOCK_DGRAM)
            address = ('127.0.0.1', 50000+self.id)
            new_socket.bind(address)
            #set the timeout for receiving to be 2 seconds
            new_socket.settimeout(1)

            #receiver
            while True:
                try:
                    data, addr = new_socket.recvfrom(4096)
                    print(data)
                    if data.split()[2] ==  "request":
                        response_data = "A ping response message was received from Peer " + str(self.id)
                        new_socket.sendto(response_data.encode(), ('127.0.0.1', 50000 + int(data.split()[-1])))
                except timeout:
                    break;
            #wait for 4 seconds
            time.sleep(3)
            new_socket.close()


    def tcp():
        pass


    def get_input():
        pass





def main(argv):
    #check user input
    if len(argv) != 4:
        print("Error, Usage: python3 cdht.py [id of the peer] [first successor] [second successor]")
        sys.exit()

    #create the instance of the peer
    newpeer = Peer(argv[1], argv[2], argv[3])
    #print(f"The id of the peer is {newpeer.id}, the first successor is {newpeer.successor1}, the second processor is {newpeer.successor2}")

    newpeer.pingUDP()


if __name__ == "__main__":
    main(sys.argv)
