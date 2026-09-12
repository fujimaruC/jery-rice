#!/bin/sh



set -u
ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)"
S="$(mktemp -d)"
trap 'rm -rf "$S"' EXIT

"$ROOT/install.sh" --root "$S" --no-packages --yes >/dev/null 2>&1 \
    || { echo "install failed"; exit 1; }

MANIFEST="$S/state/jeri-desktop/manifest.lst"
[ -f "$MANIFEST" ] || { echo "manifest missing"; exit 1; }
[ -s "$MANIFEST" ] || { echo "manifest empty"; exit 1; }


awk -F"\t" '{print $2}' "$MANIFEST" | while read -r f; do
    [ -f "$f" ] || { echo "manifest path missing: $f"; exit 1; }
done || exit 1


"$ROOT/uninstall.sh" --root "$S" --yes >/dev/null 2>&1 \
    || { echo "uninstall failed"; exit 1; }

REMAINING="$(find "$S" -type f | grep -v '/logs/install.log' | grep -v '/backup/' | wc -l)"
if [ "$REMAINING" -ne 0 ]; then
    echo "leftovers after uninstall:"
    find "$S" -type f | grep -v '/logs/install.log' | grep -v '/backup/'
    exit 1
fi
echo "ok"