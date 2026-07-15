#!/usr/bin/env bash
# Builds the WASM MySQL server. Yes, you read that right.
#
# vitess's go/mysql package references syscall.SIGHUP, which does not exist
# on GOOS=js because browsers famously do not deliver POSIX signals to tabs.
# We vendor the deps and rewrite SIGHUP to its raw signal number (1), which
# compiles fine and will simply never fire. This is the most reasonable
# decision made anywhere in this project.
set -euo pipefail
cd "$(dirname "$0")"

OUT="${1:-../site/mysqld.wasm}"

go mod vendor

PATCH_TARGET="vendor/github.com/dolthub/vitess/go/mysql/auth_server_static.go"
sed -i.bak 's/syscall\.SIGHUP/syscall.Signal(0x1)/g' "$PATCH_TARGET"
rm -f "$PATCH_TARGET.bak"

GOOS=js GOARCH=wasm go build -mod=vendor -ldflags="-s -w" -o "$OUT" .

cp "$(go env GOROOT)/lib/wasm/wasm_exec.js" ../site/wasm_exec.js 2>/dev/null \
  || cp "$(go env GOROOT)/misc/wasm/wasm_exec.js" ../site/wasm_exec.js

ls -lh "$OUT"
