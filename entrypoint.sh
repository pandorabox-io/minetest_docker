#!/bin/sh

mkdir -p crashlogs
ulimit -c unlimited
/usr/local/bin/minetestserver --config /etc/minetest/minetest.conf

DATE_FMT=`date +"%Y-%m-%d_%H-%M"`
tail -n1000 debug.txt | grep ERROR > crashlogs/crash_${DATE_FMT}.txt
