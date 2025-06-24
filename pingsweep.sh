#!/bin/bash

# Pinging a set of IP subnet, checking whether they are online or not.

echo
echo 'To fully utilise this tool, enter the subnet in this format (IP4): 192.168.#.# or 192.168.1.# '
echo
read -p '[?] Enter the subnet: ' SUBNET

CHECK=$(echo $SUBNET | cut -d'.' -f'3,4')

SELECTED=0
OPTIONS='Yes No'

# Variable for the loop
VAL1=1
VAL2=254
VAL3=1
VAL4=254


# method for: 192.168.#.#
function Subnetting_16 {
	
	echo
	NEW_SUB=$(echo $SUBNET | cut -d'.' -f"1,2")
	
	for P_IP in $(seq $VAL1 $VAL2)
	do
		PRE_IP=$NEW_SUB.$P_IP
		
		for F_IP in $(seq $VAL3 $VAL4)
		do
			IP=$PRE_IP.$F_IP

			RESULTS=$(ping -c1 -W 0.3 $IP | awk '/packets transmitted/ {print $4}')
			if [ $RESULTS -eq 1 ]
			then
				echo $IP >> ./Alive_IPs
			else
				echo $IP >> ./Dead_IPs
		fi
		done
	done
}


#method for: 192.168.1.#
function Subnetting_24 {
	
	echo
	NEW_SUB=$(echo $SUBNET | cut -d'.' -f"1,2,3")
	
	for P_IP in $(seq $VAL1 $VAL2)
	do
		IP=$NEW_SUB.$P_IP

		RESULTS=$(ping -c1 -W 0.3 $IP | awk '/packets transmitted/ {print $4}')
		
		if [ $RESULTS -eq 1 ]
		then
			echo $IP >> ./Alive_IPs
		else
			echo $IP >> ./Dead_IPs
		fi
	
	done
}


# Checking which method to use
function Default_Custom {
	read -p '[?] Do you want enter your starting and finishing point (yes/no)? ' opt
	
	if [ $opt = 'yes' ]
	then
		echo

		read -p '[?] Enter range (Format => 35-100): ' VALUE1
		VAL1=$(echo $VALUE1 | awk -F- '{print $1}')
		VAL2=$(echo $VALUE1 | awk -F- '{print $2}')	

		if [ $CHECK = '#.#' ]
		then
			read -p '[?] Enter another range (Format => 2-100): ' VALUE2
			VAL3=$(echo $VALUE2 | awk -F- '{print $1}')
			VAL4=$(echo $VALUE2 | awk -F- '{print $2}')
				
		fi
	fi
}


echo
echo '[~] Processing...'


# Checking if the Alive_IPs or Dead_IPs files exists
if [ -e Alive_IPs ] || [ -e Dead_IPs ]
then
	rm Alive_IPs 2>/dev/null
	rm Dead_IPs 2>/dev/null
	
	echo
	echo '[+] Deleted files'
fi


echo
Default_Custom # RANGE


echo
echo '[~] Processing...'


if [ $CHECK = '#.#' ]	
then	
	Subnetting_16
else
	# Confirming /24
	CHECK=$(echo $SUBNET | cut -d'.' -f'4')
	if [ $CHECK = '#' ]
	then
		Subnetting_24
	else
		echo
		echo '[-] Invalid input'
		echo
	fi
fi


echo '[+] DONE!'
