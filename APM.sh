#!/bin/bash
ps1 () {
        cat $2 |grep $1 | head -1 | sed 's/  */ /g' | cut -f 3,4 -d " " >> $1_cpu_mem.txt
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
		#sed -i -e "1d" tempproclist.txt	
		sed -i '$ d' tempproclist.txt
		metaprockill
	fi
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
rm -f Dard_disk_utl.txt
while [ 0 ]; do
	sleep 5

        ifstat ens33 | tail -2 | head -1 | sed 's/  */ /g' | cut -f 6,8 -d " " >> RX_TX_data.txt
	rm -f hold.txt
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


