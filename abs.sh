#!/bin/bash
# MadStu's Small Install Script
cd ~
wget https://raw.githubusercontent.com/MadStu/ABS/master/newabsmn.sh
chmod 777 newabsmn.sh
sed -i -e 's/\r$//' newabsmn.sh
./newabsmn.sh
