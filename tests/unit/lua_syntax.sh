#!/bin/sh

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)"
[ -x /usr/bin/luac ] || { echo "luac not found"; exit 1; }
luac -p "$ROOT/lua/gen-conf.lua" 2>&1