#!/bin/bash
# Monitors processes
./APM1 127.0.0.1 &
./APM2 127.0.0.1 &
./APM3 127.0.0.1 &
./APM4 127.0.0.1 &
./APM5 127.0.0.1 &
./APM6 127.0.0.1 &

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
while [ 0 ]; do
	sleep 60 #replace this with actual monitor code
done


