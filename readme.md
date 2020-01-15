
minetest docker builder


# Images

* See: https://hub.docker.com/r/buckaroobanzay/minetest

# Docker-compose

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

# Branches/Tags

* 5.1.0
* backport-5
* stable
* master
