#!/bin/sh



ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)"
[ -x /usr/bin/shellcheck ] || { echo "shellcheck not found"; exit 1; }

FAIL=0
for f in install.sh uninstall.sh doctor.sh installer/lib.sh tests/run.sh tests/unit/*.sh tests/installer/*.sh; do
    [ -f "$ROOT/$f" ] || continue
    shellcheck -x "$ROOT/$f" 2>&1 || FAIL=$((FAIL+1))
done
exit "$FAIL"