#!/bin/sh

docker run --rm -it \
	-v "$(pwd)/data:/data" \
	buckaroobanzay/minetest
