#!/bin/sh

# exit on error
set -e

echo "sqlite3 patch, issue: https://github.com/pandorabox-io/pandorabox.io/issues/456"
echo "inserts or updates auth data"
cat patches/minetest_auth_insert_race.patch | patch -p1

echo "profiler expose: minetest.get_profiler_value(name)"
cat patches/lua_profiler.patch | patch -p1

echo "Disable some timestamp shenanigans"
cat patches/disable_timestamps.patch | patch -p1

echo "Deferrend mapsending patch"
cat patches/minetest_deferred_send.patch | patch -p1

echo "util/Threadpool.h"
cat patches/util_threadpool.patch | patch -p1

echo "Metrics and async mapsending"
cat patches/minetest_metrics_and_mapsending.patch | patch -p1

echo "async Map::saveBlock()"
cat patches/minetest_async_mapsave.patch | patch -p1
