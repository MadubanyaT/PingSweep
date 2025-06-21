#!/bin/bash

# Pinging a set of IP subnet, checking whether they are online or not.

echo
echo 'To fully utilise this tool, enter the subnet in this format (IP4): 192.168.#.# or 192.168.1.# '
echo
read -p '[?] Enter the subnet: ' SUBNET

CHECK=$(echo $SUBNET | cut -d'.' -f'3,4')


# method for: 192.168.#.#

function subnetting_16 {
	
	echo
	NEW_SUB=$(echo $SUBNET | cut -d'.' -f"1,2")
	
	for P_IP in $(seq 1 254)
	do
		PRE_IP=$NEW_SUB.$P_IP
		
		for F_IP in $(seq 1 254)
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

function subnetting_24 {
	
	echo
	NEW_SUB=$(echo $SUBNET | cut -d'.' -f"1,2,3")
	
	for P_IP in {1..254}
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


# Checking if the Alive_IPs or Dead_IPs files exists

if [ -e Alive_IPs ] || [ -e Dead_IPs ]
then
	rm Alive_IPS 2>/dev/null
	rm Dead_IPs 2>/dev/null
	
	echo
	echo '[+] Deleted files'
fi


echo
echo '[>] Processing...'

# Checking which method to use

if [ $CHECK = '#.#' ]	
then
	subnetting_16
else
	# Confiming /24
	CHECK=$(echo $SUBNET | cut -d'.' -f'4')
	if [ $CHECK = '#' ]
	then
		subnetting_24
	else
		echo
		echo '[-] Invalid input'
		echo
	fi
fi


echo '[+] DONE!'

