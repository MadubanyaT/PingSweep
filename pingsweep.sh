#!/bin/bash

# Pinging a set of IP subnet, checking whether they are online or not.

echo
echo 'To fully utilise this tool, enter the subnet in this format (IP4): 192.168.#.# or 192.168.1.# '
echo
read -p '[?] Enter the subnet: ' SUBNET

CHECK=$(echo $SUBNET | cut -d'.' -f3)

echo $CHECK

if [ $CHECK = '#' ]
then
	echo 2
else
	echo 1
fi

