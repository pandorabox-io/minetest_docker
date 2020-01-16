#!/bin/sh

mkdir -p /crashlogs
ulimit -c unlimited

exit_script() {
	killall minetestserver
}

trap exit_script SIGINT SIGTERM

minetestserver --config /data/minetest.conf --world /data/world/ --quiet

DATE_FMT=`date +"%Y-%m-%d_%H-%M"`
tail -n1000 /root/.minetest/debug.txt | grep ERROR > /crashlogs/crash_${DATE_FMT}.txt
