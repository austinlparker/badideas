#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "$0")/.." && pwd)
CACHE=${MYSQL_WASM_CACHE:-"$ROOT/.cache/badideas-mysql-wasm"}
OUT="$ROOT/site/mysql-wasm"

MYSQL_VERSION=5.7.44
MYSQL_ARCHIVE="mysql-boost-${MYSQL_VERSION}.tar.gz"
MYSQL_URL="https://cdn.mysql.com/Downloads/MySQL-5.7/${MYSQL_ARCHIVE}"
MYSQL_SHA256=b8fe262c4679cb7bbc379a3f1addc723844db168628ce2acf78d33906849e491

OPENSSL_TAG=OpenSSL_1_1_1w
OPENSSL_COMMIT=e04bd3433fd84e1861bf258ea37928d9845e6a86

IMAGE=badideas-mysql-wasm:3.1.64
JOBS=${JOBS:-4}
# Clang compiling MySQL's large GIS translation units is memory hungry. One
# job is deliberately the default so this also works in small Docker VMs.
MYSQL_JOBS=${MYSQL_JOBS:-1}

mkdir -p "$CACHE/downloads" "$CACHE/src" "$CACHE/build" "$OUT"

MYSQL_TARBALL="$CACHE/downloads/$MYSQL_ARCHIVE"
MYSQL_SOURCE="$CACHE/src/mysql-${MYSQL_VERSION}"
OPENSSL_SOURCE="$CACHE/src/openssl-${OPENSSL_TAG}"

if [[ ! -f "$MYSQL_TARBALL" ]]; then
  echo "Downloading MySQL ${MYSQL_VERSION} source + Boost..."
  curl --fail --location --retry 3 --output "$MYSQL_TARBALL" "$MYSQL_URL"
fi

ACTUAL_SHA=$(shasum -a 256 "$MYSQL_TARBALL" | awk '{print $1}')
if [[ "$ACTUAL_SHA" != "$MYSQL_SHA256" ]]; then
  echo "MySQL archive checksum mismatch" >&2
  echo "expected: $MYSQL_SHA256" >&2
  echo "actual:   $ACTUAL_SHA" >&2
  exit 1
fi

if [[ ! -f "$MYSQL_SOURCE/.badideas-patched" ]]; then
  if [[ -e "$MYSQL_SOURCE" ]]; then
    echo "$MYSQL_SOURCE exists but is not marked as patched; remove it and retry" >&2
    exit 1
  fi
  echo "Extracting and patching MySQL ${MYSQL_VERSION}..."
  tar -xzf "$MYSQL_TARBALL" -C "$CACHE/src"
  for patch in "$ROOT"/mysql-wasm/patches/*.patch; do
    (cd "$MYSQL_SOURCE" && git apply "$patch")
  done
  touch "$MYSQL_SOURCE/.badideas-patched"
fi

if [[ ! -d "$OPENSSL_SOURCE/.git" ]]; then
  echo "Fetching OpenSSL ${OPENSSL_TAG}..."
  git clone --depth 1 --branch "$OPENSSL_TAG" \
    https://github.com/openssl/openssl.git "$OPENSSL_SOURCE"
fi

ACTUAL_OPENSSL_COMMIT=$(git -C "$OPENSSL_SOURCE" rev-parse HEAD)
if [[ "$ACTUAL_OPENSSL_COMMIT" != "$OPENSSL_COMMIT" ]]; then
  echo "OpenSSL source is not the pinned commit" >&2
  echo "expected: $OPENSSL_COMMIT" >&2
  echo "actual:   $ACTUAL_OPENSSL_COMMIT" >&2
  exit 1
fi

echo "Building the pinned Emscripten toolchain image..."
docker build --platform linux/amd64 --tag "$IMAGE" "$ROOT/mysql-wasm"

echo "Building MySQL's embedded server library and browser module..."
docker run --rm --platform linux/amd64 \
  --env "JOBS=$JOBS" \
  --env "MYSQL_JOBS=$MYSQL_JOBS" \
  --volume "$ROOT/mysql-wasm:/project:ro" \
  --volume "$MYSQL_SOURCE:/mysql-src:ro" \
  --volume "$OPENSSL_SOURCE:/openssl-src:ro" \
  --volume "$CACHE/build:/build" \
  --volume "$OUT:/out" \
  "$IMAGE" /project/build-inside.sh

echo "Built browser MySQL module:"
du -h "$OUT"/*
