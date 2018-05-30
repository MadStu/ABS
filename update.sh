cd ~
~/*bsolute/absolute-cli stop
sleep 10
mv ~/*bsolute ~/OldAbsoluteFiles
wget https://github.com/absolute-community/absolute/releases/download/12.2.2/absolute_12.2.2_linux.tar.gz
tar -zxvf absolute_12.2.2_linux.tar.gz
mv absolute_12.2.2_linux ~/Absolute
rm absolute_12.2.2_linux.tar.gz

sudo rm -rf /usr/local/bin/absolute-cli
sudo rm -rf /usr/local/bin/absoluted

sudo ln -s $PWD/Absolute/absolute-cli /usr/local/bin/absolute-cli
sudo ln -s $PWD/Absolute/absoluted /usr/local/bin/absoluted

absoluted -daemon

echo " "
echo "  - Now Start-Alias in your windows wallet"
echo " "