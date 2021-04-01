# Stage 1 build
FROM alpine:3.13.4

ENV GAME_BRANCH=5.4.0
ENV GAME_REPO=https://github.com/minetest/minetest_game.git

ENV ENGINE_BRANCH=5.4.0
ENV ENGINE_REPO=https://github.com/minetest/minetest

# RelWithDebInfo
# Release
# Debug
ENV ENGINE_BUILD_TYPE=Release


RUN apk add --no-cache build-base irrlicht-dev cmake bzip2-dev libpng-dev jpeg-dev \
  sqlite-dev curl-dev zlib-dev gmp-dev jsoncpp-dev luajit-dev \
  git postgresql-dev

RUN mkdir /git

# git setup
RUN git config --global user.email "you@example.com" && \
 git config --global user.name "somename"

# prometheus cpp
RUN cd /git && git clone --depth 1 https://github.com/jupp0r/prometheus-cpp.git -b v0.9.0 && \
  cd prometheus-cpp && \
  git submodule init && \
  git submodule update && \
  cmake . && make -j4 && make install

# spatialindex
RUN cd /git && git clone --depth 1 https://github.com/libspatialindex/libspatialindex -b 1.9.3 && \
  cd libspatialindex && \
  cmake . && make -j4 && make install

# download minetest engine
RUN cd /git && git clone ${ENGINE_REPO} minetest && \
	cd minetest && \
	git checkout ${ENGINE_BRANCH}

# minetest game
RUN cd /git/minetest/ && rm -rf games/minetest_game && \
 git clone --depth 1 ${GAME_REPO} games/minetest_game -b ${GAME_BRANCH}

# apply patches
COPY patches/* /git/minetest/patches/
COPY patch-engine.sh /git/minetest/patch-engine.sh
RUN cd /git/minetest/ && ./patch-engine.sh

# compile engine
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
  -DENABLE_PROMETHEUS=TRUE \
	-DVERSION_EXTRA=docker &&\
 make -j4 &&\
 make install

# Stage 2 package
FROM alpine:3.13.4

RUN apk add --no-cache bzip2 \
  sqlite-libs curl zlib gmp jsoncpp luajit \
  postgresql-libs

WORKDIR /data

COPY --from=0 /usr/local/lib/libspatialindex* /usr/local/lib/
COPY --from=0 /usr/local/share/minetest /usr/local/share/minetest
COPY --from=0 /usr/local/bin/minetestserver /usr/local/bin/minetestserver
COPY ./entrypoint.sh /entrypoint.sh

EXPOSE 30000/udp

CMD ["/entrypoint.sh"]
