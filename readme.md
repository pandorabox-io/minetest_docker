
minetest docker builder

![docker](https://github.com/pandorabox-io/minetest_docker/workflows/docker/badge.svg)

# Images

* See: https://hub.docker.com/r/buckaroobanzay/minetest

# Docker-compose

Example config:

```yml
version: "2"

services:
 minetest:
  image: buckaroobanzay/minetest:backport-5
  restart: always
  ports:
   - "30000:30000/udp"
  volumes:
   - "./data/minetest:/data"
   - "./data/crashlogs:/crashlogs"
   - "./data/minetest/debug.txt:/root/.minetest/debug.txt"
```

# Available patches

In the `patches` folder

## minetest_async_pg.patch

Async postgres map- and player-insert/update (performance)

## sendmove_null-check.patch

Custom fix for https://github.com/minetest/minetest/issues/9387

## lua_profiler.patch

Exposes the engine profiler with `minetest.get_profiler_value()`

## old_pandorabox.patch (deprecated)

Async pg and various prometheus monitoring thing (don't use that one!)


# Branches/Tags

* stable-5
* master
