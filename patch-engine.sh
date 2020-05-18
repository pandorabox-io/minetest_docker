#!/bin/sh

# exit on error
set -e

# sqlite3 patch, issue: https://github.com/pandorabox-io/pandorabox.io/issues/456
cat patches/minetest_auth_insert_race.patch | patch -p1

# auth iterate performance patch
cat patches/auth_iterater_perf.patch | patch -p1

# async map sending with a threadpool
cat patches/minetest_async_mapsending.patch | patch -p1

# async pg map and player save
cat patches/minetest_async_pg.patch | patch -p1

# particle spawner range limit
cat patches/minetest_particlespawner_range.patch | patch -p1

# constants adjustments
cat patches/minetest_mapsending_constants.patch | patch -p1

# profiler expose: minetest.get_profiler_value(name)
cat patches/lua_profiler.patch | patch -p1

cat patches/minetest_disable_luajit_exception_wrapper.patch | patch -p1
