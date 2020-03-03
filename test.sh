#!/bin/sh
# simple integration test

CFG=/tmp/minetest.conf

cat <<EOF > ${CFG}
# test config
EOF

mkdir -p ${WORLDDIR}
chmod 777 ${MTDIR} -R
docker run --rm -i \
	-v ${CFG}:/data/minetest.conf:ro \
	-v $(pwd)/test_mod:/data/world/worldmods/test_mod \
	buckaroobanzay/minetest:${BRANCH}

#test -f ${WORLDDIR}/integration_test.json && exit 0 || exit 1
