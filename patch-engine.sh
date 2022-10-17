#!/bin/sh

# exit on error
set -e

echo "Patch: Disable some timestamp shenanigans"
cat patches/disable_timestamps.patch | patch -p1

echo "Patch: Deferrend mapsending patch"
cat patches/minetest_deferred_send.patch | patch -p1

#echo "Patch: Metrics and async mapsending"
#cat patches/minetest_metrics_and_mapsending.patch | patch -p1

#echo "Patch: async pg map and player save"
#cat patches/minetest_async_pg.patch | patch -p1

echo "Patch: get_player_info() with debug info"
cat patches/player_debug_info.patch | patch -p1

echo "Patch: disable frequent pg verify and ping"
cat patches/disable_pg_verify_ping.patch | patch -p1