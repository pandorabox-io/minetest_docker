#!/bin/sh
# simple integration test

CFG=/tmp/minetest.conf
MTDIR=/tmp/mt
WORLDDIR=${MTDIR}/worlds/world

cat <<EOF > ${CFG}
# test config
EOF



mkdir -p ${WORLDDIR}
chmod 777 ${MTDIR} -R
docker run --rm -i \
	-v ${CFG}:/etc/minetest/minetest.conf:ro \
	-v ${MTDIR}:/var/lib/minetest/.minetest \
	-v $(pwd)/test_mod:/var/lib/minetest/.minetest/worlds/world/worldmods/test_mod \
	buckaroobanzay/minetest:${BRANCH}

test -f ${WORLDDIR}/integration_test.json && exit 0 || exit 1
