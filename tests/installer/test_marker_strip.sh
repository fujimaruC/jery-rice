#!/bin/sh



set -u
ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)"
S="$(mktemp -d)"
trap 'rm -rf "$S"' EXIT

CONF="$S/home/.config/hypr/hyprland.conf"
mkdir -p "$(dirname "$CONF")"
printf 'general {\n    border_size = 1\n}\n' > "$CONF"

"$ROOT/install.sh" --root "$S" --no-packages --yes >/dev/null 2>&1
grep -q ' # jeri-desktop$' "$CONF" || { echo "marker line missing after install"; exit 1; }
grep -q '^# jeri-desktop$' "$CONF" || { echo "marker comment missing after install"; exit 1; }

"$ROOT/uninstall.sh" --root "$S" --yes >/dev/null 2>&1

if grep -q 'jeri-desktop' "$CONF"; then
    echo "marker still present after uninstall"; grep jeri-desktop "$CONF"; exit 1
fi

[ "$(sed '/^[[:space:]]*$/d' "$CONF")" = "$(printf 'general {\n    border_size = 1\n}' | sed '/^[[:space:]]*$/d')" ] \
    || { echo "conf not restored"; exit 1; }
echo "ok"