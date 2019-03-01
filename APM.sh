#!/bin/bash
ps1 () {
        cpu=$(cat $2 | grep $1 | head -1 | sed 's/  */ /g' | cut -f 3 -d " ")
	mem=$(cat $2 | grep $1 | head -1 | sed 's/  */ /g' | cut -f 4 -d " ")
	echo -e -n "$cpu,$mem," >> master.csv
}

# Monitors processes
./APM1 192.168.1.141 &
./APM2 192.168.1.141 &
./APM3 192.168.1.141 &
./APM4 192.168.1.141 &
./APM5 192.168.1.141 &
./APM6 192.168.1.141 &


ps | grep APM > tempproclist.txt

prockill () {
	x=`echo $1 | awk '{print $1;}'`
	echo $x
	kill -9 $x
}

metaprockill () {
	text=echo cat tempproclist.txt
	if [ -z "$text" ]; then
		echo killing `tail -1 tempproclist.txt`
		prockill `tail -1 tempproclist.txt`	
		sed -i '$ d' tempproclist.txt
		metaprockill
		rm -f tempproclist.txt
	fi
	rm -f hold.txt
	echo 'ow'
}

trap metaprockill EXIT
rm -f APM1_cpu_mem.txt
rm -f APM2_cpu_mem.txt
rm -f APM3_cpu_mem.txt
rm -f APM4_cpu_mem.txt
rm -f APM5_cpu_mem.txt
rm -f APM6_cpu_mem.txt
rm -f RX_TX_data.txt
rm -f sda_writeKB.txt
rm -f Hard_disk_utl.txt
rm -f master.csv
printf "Time,APM 1 CPU,APM 1 Memory,APM 2 CPU,APM 2 Memory,APM 3 CPU,APM 3 Memory,APM 4 CPU,APM 4 Memory,APM 5 CPU,APM 5 Memory,APM 6 CPU,APM 6 Memory,RX Data,TX Data,Disk Access Rates,Disk Utilization" >> master.csv
printf "\n" >> master.csv
while [ 0 ]; do
	sleep 5
	echo -en "$SECONDS," >> master.csv
        RX=$(ifstat ens33 | tail -2 | head -1 | sed 's/  */ /g' | cut -f 6 -d " ")
	TX=$(ifstat ens33 | tail -2 | head -1 | sed 's/  */ /g' | cut -f 8 -d " ")
	rm -f hold.txt
        ps -aux > hold.txt
        ps1 APM1 hold.txt
        ps1 APM2 hold.txt
        ps1 APM3 hold.txt
        ps1 APM4 hold.txt
        ps1 APM5 hold.txt
        ps1 APM6 hold.txt
	rm -f hold.txt
        writes=$(iostat | grep sda | sed 's/  */ /g' | cut -f 4 -d " ")
        diskutil=$(df /dev/mapper/centos-root | tail -1 | sed 's/  */ /g' | cut -f 5 -d " ")
	echo -en "$RX,$TX,$writes,$diskutil\n" >> master.csv

done
