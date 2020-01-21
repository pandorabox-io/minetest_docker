#!/bin/sh

mkdir -p /crashlogs
ulimit -c unlimited

minetestserver --config /data/minetest.conf --world /data/world/ --quiet &
pid=$!

exit_script() {
        kill $pid
}

trap exit_script SIGINT SIGTERM

sleep inf &
wait


DATE_FMT=`date +"%Y-%m-%d_%H-%M"`
tail -n1000 /root/.minetest/debug.txt | grep ERROR > /crashlogs/crash_${DATE_FMT}.txt
