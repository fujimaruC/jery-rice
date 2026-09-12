#!/bin/sh


ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)"
TMPD="$(mktemp -d)"
lua "$ROOT/lua/gen-conf.lua" -o "$TMPD/jeri-inject.conf" 2>&1
if diff -q "$ROOT/config/hypr/jeri-inject.conf" "$TMPD/jeri-inject.conf" >/dev/null 2>&1; then
    rm -rf "$TMPD"
    exit 0
else
    echo "golden mismatch"
    diff "$ROOT/config/hypr/jeri-inject.conf" "$TMPD/jeri-inject.conf"
    rm -rf "$TMPD"
    exit 1
fi