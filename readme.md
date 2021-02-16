
minetest docker builder
------------

Customized and patched minetest engine in a container

![docker](https://github.com/pandorabox-io/minetest_docker/workflows/docker/badge.svg)

# Features

* Postgresql support
* Prometheus metrics support
* Async mapsending
* Various fixes / perf. improvements

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
