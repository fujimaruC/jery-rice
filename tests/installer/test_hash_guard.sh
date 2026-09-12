#!/bin/sh


set -u
ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)"
S="$(mktemp -d)"
trap 'rm -rf "$S"' EXIT

"$ROOT/install.sh" --root "$S" --no-packages --yes >/dev/null 2>&1

TARGET="$S/config/home/.config/jeri-desktop/shell/theme/Colors.qml"
printf '\n// user edit\n' >> "$TARGET"

out="$("$ROOT/uninstall.sh" --root "$S" --yes 2>&1)"
echo "$out" | grep -q "hash mismatch" || { echo "no hash-mismatch guard triggered"; exit 1; }
[ -f "$TARGET" ] || { echo "tampered file was deleted!"; exit 1; }
echo "ok"