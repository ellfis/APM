#!/bin/bash

ps1 () {
	cat $2 |grep $1 | head -1 | sed 's/  */ /g' | cut -f 3,4 -d " " >> $1_cpu_mem.txt
}

while true
do
sleep 5

	ifstat ens33 | tail -2 | head -1 | sed 's/  */ /g' | cut -f 6,8 -d " " >> RX_TX_data.txt
	ps -aux >> hold.txt
	ps1 APM1 hold.txt
	ps1 APM2 hold.txt
	ps1 APM3 hold.txt
	ps1 APM4 hold.txt
	ps1 APM5 hold.txt
	ps1 APM6 hold.txt
	iostat | grep sda | sed 's/  */ /g' | cut -f 4 -d " " >> sda_writeKB.txt
	df /dev/mapper/centos-root | tail -1 | sed 's/  */ /g' | cut -f 5 -d " " >> Dard_disk_utl.txt	
	
done
