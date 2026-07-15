#!/usr/bin/env bash
# Vendors the php-wasm package into site/php-wasm, keeping only what the
# browser actually fetches: the JS glue, the PHP 8.4 web build, and the one
# wasm binary it references. The other ~150MB of interpreters are someone
# else's bad idea.
set -euo pipefail
cd "$(dirname "$0")/.."

npm install --no-save php-wasm@0.1.0

PKG=node_modules/php-wasm
rm -rf site/php-wasm
mkdir -p site/php-wasm

cp "$PKG"/*.mjs site/php-wasm/
cp "$PKG"/LICENSE "$PKG"/NOTICE site/php-wasm/

# Drop the node/webview/SDL builds and every PHP version except 8.4-web.
rm -f site/php-wasm/*-node.mjs site/php-wasm/*_sdl-web.mjs
for v in 8.0 8.1 8.2 8.3 8.5; do rm -f "site/php-wasm/php$v-web.mjs"; done

# Keep only the wasm binaries the 8.4 web build actually references.
grep -oE '[0-9a-f]{40}\.wasm' "$PKG/php8.4-web.mjs" | sort -u | while read -r w; do
  cp "$PKG/$w" site/php-wasm/
done

du -sh site/php-wasm
