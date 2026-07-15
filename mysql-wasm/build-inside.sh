#!/usr/bin/env bash
set -euo pipefail

JOBS=${JOBS:-4}
MYSQL_JOBS=${MYSQL_JOBS:-1}

mkdir -p \
  /build/openssl \
  /build/openssl-install \
  /build/mysql-host \
  /build/mysql-wasm \
  /out

if [[ ! -f /build/openssl/Makefile ]]; then
  echo "Configuring OpenSSL for WebAssembly..."
  cd /build/openssl
  CC=emcc AR=emar RANLIB=emranlib NM=emnm \
    perl /openssl-src/Configure gcc \
      --prefix=/build/openssl-install \
      --openssldir=/build/openssl-install/ssl \
      no-asm no-shared no-dso no-engine no-tests no-async -pthread
fi

if [[ ! -f /build/openssl-install/lib/libssl.a ]]; then
  echo "Building OpenSSL for WebAssembly..."
  emmake make -C /build/openssl -j"$JOBS"
  emmake make -C /build/openssl install_sw
fi

echo "Building MySQL's native source generators..."
cmake -S /mysql-src -B /build/mysql-host \
  -DBADIDEAS_HOST_TOOLS_ONLY=ON \
  -DWITHOUT_SERVER=ON \
  -DWITH_UNIT_TESTS=OFF \
  -DWITH_RAPID=OFF \
  -DWITH_NDBCLUSTER=OFF \
  -DWITH_BOOST=/mysql-src/boost/boost_1_59_0 \
  -DLOCAL_BOOST_DIR=/mysql-src/boost/boost_1_59_0 \
  -DBOOST_INCLUDE_DIR=/mysql-src/boost/boost_1_59_0 \
  -DWITH_SSL=system \
  -DFORCE_UNSUPPORTED_COMPILER=ON \
  -DSTACK_DIRECTION=-1 \
  -DCMAKE_BUILD_TYPE=Release
cmake --build /build/mysql-host --target comp_err comp_sql --parallel "$JOBS"

echo "Configuring MySQL ${MYSQL_VERSION:-5.7.44} for WebAssembly..."
cd /build/mysql-wasm
emcmake cmake /mysql-src \
  -DWITH_BOOST=/mysql-src/boost/boost_1_59_0 \
  -DLOCAL_BOOST_DIR=/mysql-src/boost/boost_1_59_0 \
  -DBOOST_INCLUDE_DIR=/mysql-src/boost/boost_1_59_0 \
  -DWITH_EMBEDDED_SERVER=ON \
  -DWITH_UNIT_TESTS=OFF \
  -DWITH_RAPID=OFF \
  -DWITH_SSL=/build/openssl-install \
  -DOPENSSL_ROOT_DIR=/build/openssl-install \
  -DOPENSSL_INCLUDE_DIR=/build/openssl-install/include \
  -DOPENSSL_LIBRARY=/build/openssl-install/lib/libssl.a \
  -DCRYPTO_LIBRARY=/build/openssl-install/lib/libcrypto.a \
  -DWITH_ZLIB=bundled \
  -DWITH_EDITLINE=bundled \
  -DWITH_LIBEVENT=bundled \
  -DENABLE_DTRACE=OFF \
  -DWITH_SYSTEMD=OFF \
  -DWITH_INNODB_MEMCACHED=OFF \
  -DWITHOUT_ARCHIVE_STORAGE_ENGINE=ON \
  -DWITHOUT_BLACKHOLE_STORAGE_ENGINE=ON \
  -DWITHOUT_FEDERATED_STORAGE_ENGINE=ON \
  -DWITHOUT_PARTITION_STORAGE_ENGINE=ON \
  -DWITH_EXAMPLE_STORAGE_ENGINE=OFF \
  -DWITH_NDBCLUSTER=OFF \
  -DFORCE_UNSUPPORTED_COMPILER=ON \
  -DSTACK_DIRECTION=-1 \
  -DCMAKE_BUILD_TYPE=MinSizeRel \
  -DCMAKE_C_FLAGS=-pthread \
  '-DCMAKE_CXX_FLAGS=-pthread -std=gnu++11 -Wno-enum-constexpr-conversion' \
  -DCMAKE_EXE_LINKER_FLAGS=-pthread

echo "Compiling MySQL's embedded server library for WebAssembly..."
cp /build/mysql-host/scripts/comp_sql /build/mysql-wasm/scripts/comp_sql
PATH="/build/mysql-host/scripts:/build/mysql-host/extra:$PATH" \
  emmake make GenBootstrapPriv GenSysSchema
PATH="/build/mysql-host/scripts:/build/mysql-host/extra:$PATH" \
  emmake make -j"$MYSQL_JOBS" mysqlserver

echo "Linking the browser module..."
em++ /project/mysql_wasm.cc \
  /build/mysql-wasm/archive_output_directory/libmysqld.a \
  -I/mysql-src/include \
  -I/mysql-src/libbinlogevents/export \
  -I/build/mysql-wasm/include \
  -pthread \
  -std=gnu++11 \
  -Os \
  --no-entry \
  --embed-file /mysql-src/sql/share/charsets@/mysql/share/charsets \
  --embed-file /build/mysql-wasm/sql/share/english/errmsg.sys@/mysql/share/english/errmsg.sys \
  -sMODULARIZE=1 \
  -sEXPORT_ES6=1 \
  -sEXPORT_NAME=createMysqlModule \
  -sENVIRONMENT=web,worker \
  -sEXPORTED_FUNCTIONS=_mysql_wasm_init,_mysql_wasm_query,_mysql_wasm_shutdown \
  -sEXPORTED_RUNTIME_METHODS=cwrap,FS \
  -sALLOW_MEMORY_GROWTH=1 \
  -sINITIAL_MEMORY=268435456 \
  -sMAXIMUM_MEMORY=2147483648 \
  -sPTHREAD_POOL_SIZE=8 \
  -sEXIT_RUNTIME=0 \
  -sFILESYSTEM=1 \
  -o /out/mysql.mjs

cp /mysql-src/LICENSE /out/LICENSE.mysql
cp /openssl-src/LICENSE /out/LICENSE.openssl
