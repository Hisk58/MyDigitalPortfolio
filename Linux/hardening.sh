#!/bin/bash

clear
echo "Hardening script is going to execute!"
echo ""
echo "If you wish to abort press CTRL + Z buttons together."
echo ""

if (( $EUID != 0)); then
	echo "execute script as root!"
	exit
fi
echo "################ UPDATING MACHINE ################"
apt-get update
apt-get -y upgrade
apt-get -y dist-upgrade
echo "################ CLEANING MACHINE ################"
apt-get clean
apt-get -y autoremove

read -p "Do you also want to install Apache? [y/n]" answer
if [ $answer = y ]
then
	echo "Installing Apache 2 & configuring it for you..."
	apt-get install -y apache2
	ufw allow 'Apache'
	systemctl restart apache2.service
fi

read -p "Do you also want to install Git? [y/n]" answer
if [ $answer = y ]
then
	echo "Installing Git & cloning your repository..."
	apt install -y git-all
	apt install -y make libssl-dev libghc-zlib-dev libcurl4-gnutls-dev libexpat1-dev gettext unzip
	read -p "Enter a file name for cloning your GitHub repository: " namefile
	mkdir $namefile
	read -p "Enter your github name: " linkgitname
	read -p "Enter your repo name: " linkgitrepo
	env -i 
	git clone https://github.com/$linkgitname/$linkgitrepo.git $namefile/
fi

echo "##########"
echo "Script is done!"
