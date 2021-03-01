#!/bin/sh

# exit on error
set -e

echo "sqlite3 patch, issue: https://github.com/pandorabox-io/pandorabox.io/issues/456"
echo "inserts or updates auth data"
cat patches/minetest_auth_insert_race.patch | patch -p1

echo "Disable some timestamp shenanigans"
cat patches/disable_timestamps.patch | patch -p1

echo "Deferrend mapsending patch"
cat patches/minetest_deferred_send.patch | patch -p1

echo "Metrics and async mapsending"
cat patches/minetest_metrics_and_mapsending.patch | patch -p1

echo "async pg map and player save"
cat patches/minetest_async_pg.patch | patch -p1
