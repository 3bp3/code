#!/bin/bash
#default
#Mac version need -K option in ssh-add command

read -p "Enter username of the server: " username
ssh-keygen -f ~/.ssh/cse_id_rsa -t rsa -b 4096 -C "$username@cse.unsw.edu.au"

ssh-copy-id -i ~/.ssh/cse_id_rsa.pub $username@cse.unsw.edu.au

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/cse_id_rsa

read -p "enter server nick name you want to use: e.g.cse " servername
echo "Host $servername 
    	User $username
    	HostName weber.cse.unsw.edu.au
    	IdentityFile ~/.ssh/cse_id_rsa" >> ~/.ssh/config


