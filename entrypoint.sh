#!/bin/sh

mkdir -p /crashlogs
ulimit -c unlimited

minetestserver ${ADDITIONAL_PARAMS} --config /data/minetest.conf --world /data/world/ --quiet &
pid=$!

sleep inf &
sleep_pid=$!

exit_script() {
  kill $pid
	kill $sleep_pid
}

trap exit_script INT
trap exit_script TERM

wait $pid


DATE_FMT=`date +"%Y-%m-%d_%H-%M"`
tail -n1000 /root/.minetest/debug.txt | grep ERROR > /crashlogs/crash_${DATE_FMT}.txt
