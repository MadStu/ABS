#!/bin/bash
clear
sleep 1
if [ -e getabsinfo.json ]
then
	echo " "
	echo "Script running already?"
	echo " "

else
echo "blah" > getabsinfo.json

sudo apt-get install jq pwgen -y

#killall absoluted
#rm -rf abs*
#rm -rf .abs*

wget https://github.com/absolute-community/absolute/releases/download/12.2.1/absolute_12.2.1_linux.tar.gz
tar -zxvf absolute_12.2.1_linux.tar.gz
mv absolute_12.2.1_linux ~/absolute
rm absolute_12.2.1_linux.tar.gz

mkdir ~/.absolutecore
RPCU=$(pwgen -1 4 -n)
PASS=$(pwgen -1 14 -n)
EXIP=$(curl ipinfo.io/ip)
printf "rpcuser=rpc$RPCU\nrpcpassword=$PASS\nrpcport=18878\nrpcthreads=8\nrpcallowip=127.0.0.1\nbind=$EXIP:18888\nmaxconnections=128\ngen=0\nexternalip=$EXIP\ndaemon=1\n\naddnode=139.99.42.106:18888\naddnode=139.99.98.145:18888\naddnode=51.255.174.238:18888\naddnode=54.37.14.240:18888\naddnode=164.132.195.79:18888\naddnode=208.167.248.187:18888\naddnode=45.77.146.105:18888\naddnode=45.77.221.206:18888\naddnode=45.76.171.105:18888\naddnode=54.37.17.154:18888\naddnode=54.36.162.69:18888\naddnode=151.80.142.66:18888\naddnode=54.36.162.72:18888\naddnode=91.134.137.168:18888\naddnode=54.36.162.71:18888\naddnode=91.134.139.112:18888\naddnode=91.134.139.255:18888\naddnode=54.36.162.70:18888\naddnode=139.99.98.145:18888\naddnode=51.255.174.238:18888\naddnode=54.37.14.240:18888\naddnode=164.132.195.79:18888\naddnode=140.42.20.223:18888\naddnode=168.215.75.10:18888\naddnode=168.215.75.11:18888\naddnode=168.215.75.12:18888\naddnode=168.215.75.13:18888\naddnode=80.211.6.67:18888\naddnode=45.76.47.71:18888\naddnode=45.63.117.26:18888\naddnode=108.61.166.109:18888\naddnode=45.77.226.106:18888\naddnode=140.82.54.227:18888\naddnode=45.77.58.107:18888\naddnode=8.9.31.133:18888\naddnode=199.247.6.168:18888\naddnode=45.32.183.227:18888\naddnode=199.247.25.268:18888\naddnode=185.87.49.227:18888\naddnode=212.237.0.210:18888\naddnode=80.212.12.215:18888\naddnode=212.237.7.179:18888\naddnode=18.204.212.162:18888\naddnode=18.205.29.91:18888\naddnode=80.211.226.166:18888\naddnode=18.218.92.139:18888\naddnode=209.182.216.230:18888\naddnode=140.82.44.51:18888\naddnode=178.32.103.49:18888\naddnode=178.32.110.184:18888\naddnode=108.61.117.146:18888\naddnode=178.32.111.28:18888\naddnode=108.61.221.27:18888\naddnode=54.38.242.135:18888\naddnode=176.31.90.219:18888\naddnode=92.222.150.163:18888\naddnode=5.196.114.151:18888\naddnode=5.196.43.184:18888\naddnode=160.226.219.173:18888\naddnode=88.5.209.230:18888\naddnode=80.211.45.239:18888\naddnode=165.227.81.15:18888\naddnode=167.99.10.94:18888\naddnode=51.38.128.108:18888\n\n" > ~/.absolutecore/absolute.conf

~/absolute/absoluted -daemon
sleep 10
MKEY=$(~/absolute/absolute-cli masternode genkey)
~/absolute/absolute-cli stop
printf "masternode=1\nmasternodeprivkey=$MKEY\n\n" >> ~/.absolutecore/absolute.conf
sleep 10
~/absolute/absoluted -daemon

###########################################################################









echo "Installing more dependencies..."

#22
sudo apt-get -y install virtualenv python-virtualenv

echo "Downloading Sentinel..."

#23
git clone https://github.com/absolute-community/sentinel.git && cd sentinel
sleep 5

echo "Installing Sentinel..."

#24
virtualenv ./venv
sleep 2
./venv/bin/pip install -r requirements.txt
sleep 2

echo "Inserting cron entry..."

#25
crontab -l > mycron
echo "* * * * * cd /home/$USER/sentinel && ./venv/bin/python bin/sentinel.py >/dev/null 2>&1" >> mycron
crontab mycron
rm mycron
sleep 10
cd ~/sentinel

# echo "Testing Sentinel, all tests should pass..."

#26
./venv/bin/py.test ./test
sleep 1

echo "Stopping ABS daemon..."

#27
sleep 1

echo "Reindexing blockchain..."

~/absolute/absolute-cli stop
sleep 5
rm ~/.absolutecore/mncache.dat
rm ~/.absolutecore/mnpayments.dat
~/absolute/absoluted -daemon -reindex
sleep 2

################################################################################

sleep 10
ARRAY=$(~/absolute/absolute-cli getinfo)
echo "$ARRAY" > getabsinfo.json
BLOCKCOUNT=$(curl http://explorer.absolutecoin.net/api/getblockcount)
WALLETBLOCKS=$(jq '.blocks' getabsinfo.json)
while [ "$menu" != 1 ]; do
	case "$WALLETBLOCKS" in
		"$BLOCKCOUNT" )      
			echo "Complete!"
			menu=1
			break
			;;
		* )
			clear
			echo " "
			echo " "
			echo "  Keep waiting..."
			echo " "
			echo "  Blocks required: $BLOCKCOUNT"
			echo "    Blocks so far: $WALLETBLOCKS"
			echo " "
			echo " "
			echo " "
			echo "  - If you see any errors or 'Blocks required' is blank,"
			echo "    you are safe to exit from this screen by holding:"
			echo "    CTRL + C"
			echo " "
			echo "  - Holding CTRL + C will exit this script and the block"
			echo "    sync will then continue in the background."
			echo " "
			echo "  - If you exit this script early, you'll need to grab the"
			echo "    masternode genkey yourself from the absolute.conf file."
			echo " "
			sleep 20
			BLOCKCOUNT=$(curl http://explorer.absolutecoin.net/api/getblockcount)
			ARRAY=$(~/absolute/absolute-cli getinfo)
			echo "$ARRAY" > getabsinfo.json
			WALLETBLOCKS=$(jq '.blocks' getabsinfo.json)
			;;
	esac
done
#echo "Now wait for AssetID: 999..."
sleep 1
MNSYNC=$(~/absolute/absolute-cli mnsync status)
echo "$MNSYNC" > mnabssync.json
ASSETID=$(jq '.AssetID' mnabssync.json)
echo "Current Asset ID: $ASSETID"
ASSETTARGET=999
while [ "$meanu" != 1 ]; do
	case "$ASSETID" in
		"$ASSETTARGET" )      
			clear
			echo " "
			echo " "
			echo "  No more waiting :) "
			echo " "
			echo "  AssetID: $ASSETID"
			sleep 2
			meanu=1
			break
			;;
		* )
			clear
			echo " "
			echo " "
			echo "  Keep waiting... "
			echo " "
			echo "  Looking for: 999"
			echo "      AssetID: $ASSETID"
			echo " "
			echo " "
			echo " "
			echo "  - If you see any errors, you are safe"
			echo "    to exit from this screen by holding:"
			echo "    CTRL + C"
			echo " "
			echo "  - Holding CTRL + C will exit this script and the"
			echo "    block sync will then continue in the background."
			echo " "
			echo "  - If you exit this script early, you'll need to grab the"
			echo "    masternode genkey yourself from the absolute.conf file."
			echo " "
			sleep 5
			MNSYNC=$(~/absolute/absolute-cli mnsync status)
			echo "$MNSYNC" > mnabssync.json
			ASSETID=$(jq '.AssetID' mnabssync.json)
			;;
	esac
done
rm mnabssync.json
echo " "
echo " "
~/absolute/absolute-cli mnsync status
echo " "


THISHOST=$(hostname -f)
sleep 3 
echo " "
echo " "
echo "Now would be a good time to setup your Transaction ID and VOUT from your windows wallet"
echo " "
sleep 3
echo "You'll need the Masternode Key which is:"
echo "$MKEY"
echo " "
sleep 3
echo "You'll also need your server IP which is:"
echo "$EXIP"
echo " "
sleep 2
echo "=================================="
echo " "
echo "So your masternode.conf should start with:"
echo " "
echo "$THISHOST $EXIP:18888 $MKEY TXID VOUT"
echo " "
echo "=================================="
echo " "
echo "Your server hostname is $THISHOST and you can change it to MN1 or MN2 or whatever you like"
echo " "
sleep 3
echo " "
echo "  - You can now Start Alias in the windows wallet!"
echo " "
echo "       Thanks for using MadStu's Install Script"
echo " "

rm getabsinfo.json

fi

