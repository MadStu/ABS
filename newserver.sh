#!/bin/bash




sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y

sudo apt-get install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils software-properties-common libgmp3-dev -y
sudo apt-get install libboost-all-dev -y
sudo add-apt-repository ppa:bitcoin/bitcoin -y
sudo apt-get update -y
sudo apt-get install libdb4.8-dev libdb4.8++-dev -y
sudo apt-get install libminiupnpc-dev -y
sudo apt-get -y install python-virtualenv virtualenv
sudo apt-get install nano jq htop git pwgen -y
PASS=$(pwgen -1 14 -n)

useradd -m -s /bin/bash absuser
echo "absuser:$PASS" | chpasswd
usermod -aG sudo absuser

dd if=/dev/zero of=/mnt/myswap.swap bs=1M count=2000
mkswap /mnt/myswap.swap
chmod 600 /mnt/myswap.swap
swapon /mnt/myswap.swap
echo -e "/mnt/myswap.swap none swap sw 0 0 \n" >> /etc/fstab

echo " "
echo " "
echo " Your new server is ready to be a masternode!"
echo " "
echo " I've created a new user with randomly generated password:"
echo " "
echo "              Username: absuser"
echo "              Password: $PASS"
echo " "
echo " Please now reboot once you've saved your password by typing:"
echo " "
echo "              reboot"
echo " "
echo " Then log back in with your new raceuser account to complete the installation."
echo " "
echo " Good luck! You got this!!"
echo " "