#!/bin/sh


set -u
ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)"
S="$(mktemp -d)"
trap 'rm -rf "$S"' EXIT

FAKE="$(mktemp -d)"
printf '#!/bin/sh\nexit 1\n' > "$FAKE/lua"
chmod +x "$FAKE/lua"
trap 'rm -rf "$S" "$FAKE"' EXIT

PATH="$FAKE:$PATH" "$ROOT/install.sh" --root "$S" --no-packages --yes >/dev/null 2>&1
[ $? -ne 0 ] || { echo "install unexpectedly succeeded (fake lua ignored)"; exit 1; }

LEFT="$(find "$S" -type f | grep -v '/logs/install.log' | wc -l)"
if [ "$LEFT" -ne 0 ]; then
    echo "pending files left after rollback:"; find "$S" -type f | grep -v '/logs/install.log'
    exit 1
fi
echo "ok"