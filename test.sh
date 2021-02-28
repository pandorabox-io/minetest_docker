#!/bin/sh
# simple integration test

CFG=/tmp/minetest.conf
MT_WORLD_DIR=/tmp/world

cat <<EOF > ${CFG}
# test config
EOF

# TODO: postgres database test
# TODO: dummy headless client test

docker run --rm -i \
	-v ${CFG}:/data/minetest.conf:ro \
	-v ${MT_WORLD_DIR}:/data/world \
	-v $(pwd)/test_mod:/data/world/worldmods/test_mod \
	-e ADDITIONAL_PARAMS= \
	buckaroobanzay/minetest:${BRANCH}

test -f ${MT_WORLD_DIR}/integration_test.json && exit 0 || exit 1
