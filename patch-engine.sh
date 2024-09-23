#!/bin/sh

# exit on error
set -e

echo "Patch: get_player_info() with debug info"
cat patches/player_debug_info.patch | patch -p1

echo "Patch: disable frequent pg verify and ping"
cat patches/disable_pg_verify_ping.patch | patch -p1