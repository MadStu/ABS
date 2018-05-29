#!/bin/bash
# MadStu's Small Install Script
cd ~
wget https://raw.githubusercontent.com/MadStu/ABS/master/newserver.sh
chmod 777 newserver.sh
sed -i -e 's/\r$//' newserver.sh
./newserver.sh
