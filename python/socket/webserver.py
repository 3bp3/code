#!/usr/bin/env python
import sys
from socket import *

# check the input has two arguments
if len(sys.argv) != 2:
    print "Please enter the port number! \n"
    sys.exit()

#initialize
server_port=int(sys.argv[1])
server_host='127.0.0.1'
server_address = (server_host, server_port)

#server-server AF_INET, TCP - SOCK_STREAM
server_socket = socket(AF_INET, SOCK_STREAM)
#binds the socket to the server address
server_socket.bind(server_address)

# server listens TCP requests from client 
# socket library queue up for 5 connect requests
server_socket.listen(5)
print "Server is listening to the port ", server_port

# deal with the request
while True:
    print("The server is ready....")
    client_socket, client_address = server_socket.accept()
    
    try:
        message = client_socket.recv(1024)
        print message
        
        # get the filename
        filename = message.split()[1]
        #read the file
        f = open(filename[1:])
        content = f.read()
        #Send HTTP header into socket
        client_socket.send('\nHTTP/1.1 200 OK\n\n')

        #Send the content of the requested file to the client
        for i in range(len(content)):
            client_socket.send(content[i])

        client_socket.close()
        
    except IOError:
        
        #Send response message for file not found
        error_message = "404 Not Found"
        client_socket.send('\nHTTP/1.1 404 Not Found\n\n')
        client_socket.send(error_message)
        print(error_message)
        client_socket.close()

server_socket.close()
sys.exit()
