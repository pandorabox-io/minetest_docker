#!/bin/sh

# exit on error
set -e

echo sqlite3 patch, issue: https://github.com/pandorabox-io/pandorabox.io/issues/456
echo inserts or updates auth data
cat patches/minetest_auth_insert_race.patch | patch -p1

echo async map sending with a threadpool
cat patches/minetest_async_mapsending.patch | patch -p1

echo constants adjustments
cat patches/minetest_mapsending_constants.patch | patch -p1

echo "profiler expose: minetest.get_profiler_value(name)"
cat patches/lua_profiler.patch | patch -p1

echo async pg map and player save
cat patches/minetest_async_pg.patch | patch -p1
