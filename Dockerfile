FROM ubuntu:19.10


ENV GAME_BRANCH=5.1.0
ENV GAME_REPO=https://github.com/minetest/minetest_game.git

ENV ENGINE_BRANCH=stable-5
ENV ENGINE_REPO=https://github.com/minetest/minetest.git
ENV ENGINE_BUILD_TYPE=RelWithDebInfo
#ENV ENGINE_BUILD_TYPE=Release

# https://github.com/minetest/minetest
RUN apt-get update &&\
 apt-get install -y build-essential libirrlicht-dev cmake libbz2-dev libpng-dev libjpeg-dev libsqlite3-dev libcurl4-openssl-dev \
	zlib1g-dev libgmp-dev libjsoncpp-dev git libluajit-5.1-dev lua5.1 \
	libjsoncpp-dev libgmp-dev postgresql-server-dev-all postgresql-client libspatialindex5 libspatialindex-dev

RUN mkdir /git

# minetest
RUN cd /git && git clone --depth 1 ${ENGINE_REPO} -b ${ENGINE_BRANCH}

RUN cd /git/minetest/ && rm -rf games/minetest_game && git clone --depth 1 ${GAME_REPO} games/minetest_game -b ${GAME_BRANCH}

# apply patches
COPY patches/* /patches/

# mtg coral place patch
RUN cd /git/minetest/games/minetest_game && cat /patches/mtg_coral_place.patch | patch -p1

# verbose sqlite3 patch, issue: https://github.com/pandorabox-io/pandorabox.io/issues/456
RUN cd /git/minetest && cat /patches/verbose_sqlite3_auth.patch | patch -p1
RUN cd /git/minetest && cat /patches/minetest_auth_insert_race.patch | patch -p1

# auth iterate performance patch
#RUN cd /git/minetest && cat /patches/auth_iterater_perf.patch | patch -p1

# async pg map and player save
RUN cd /git/minetest && cat /patches/minetest_async_pg.patch | patch -p1

# profiler expose: minetest.get_profiler_value(name)
RUN cd /git/minetest && cat /patches/lua_profiler.patch | patch -p1

# https://github.com/minetest/minetest/issues/9387
RUN cd /git/minetest && cat /patches/sendmove_null-check.patch | patch -p1

RUN cd /git/minetest && cmake . \
	-DCMAKE_INSTALL_PREFIX=/usr/local\
	-DCMAKE_BUILD_TYPE=${ENGINE_BUILD_TYPE} \
	-DRUN_IN_PLACE=FALSE\
	-DBUILD_SERVER=TRUE\
	-DBUILD_CLIENT=FALSE\
	-DENABLE_SPATIAL=TRUE\
	-DENABLE_LUAJIT=TRUE\
	-DENABLE_CURSES=TRUE\
	-DENABLE_POSTGRESQL=TRUE\
	-DENABLE_SYSTEM_GMP=TRUE \
	-DENABLE_SYSTEM_JSONCPP=TRUE \
	-DVERSION_EXTRA=docker &&\
 make -j4 &&\
 make install


FROM ubuntu:19.10

RUN groupadd minetest && useradd -m -g minetest -d /var/lib/minetest minetest && \
    apt-get update -y && \
    apt-get -y install libcurl4 libjsoncpp1 liblua5.1-0 libluajit-5.1-2 libpq5 libsqlite3-0 \
        libstdc++6 zlib1g libc6 libspatialindex5 libpq5 postgresql-client

WORKDIR /data

COPY --from=0 /usr/local/share/minetest /usr/local/share/minetest
COPY --from=0 /usr/local/bin/minetestserver /usr/local/bin/minetestserver
COPY ./entrypoint.sh /entrypoint.sh

EXPOSE 30000/udp

CMD ["/entrypoint.sh"]
