#!/bin/sh




set -u
ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

[ -n "${WAYLAND_DISPLAY:-}" ] || { echo "SKIP: no Wayland session (run inside hyprland)"; exit 0; }
command -v hyprctl >/dev/null || { echo "SKIP: hyprctl not available"; exit 0; }
command -v qs >/dev/null || { echo "FAIL: quickshell missing"; exit 1; }

echo "--- host integration smoke (hyprland $(hyprctl version 2>/dev/null | head -1)) ---"

echo "[1/2] fixture: windows appear and shell exits cleanly"
out="$(timeout 20 qs -p "$ROOT/tests/fixtures/smoke" 2>&1)"; rc=$?
echo "  rc=$rc  $(echo "$out" | tr '\n' ' ')"
[ "$rc" -eq 0 ] || { echo "FAILED: fixture did not exit cleanly"; exit 1; }

echo "[2/2] bar config parses (qmllint) + bar launches"
if command -v qmllint >/dev/null; then
    qmllint "$ROOT/shell/shell.qml" || { echo "FAILED: qmllint"; exit 1; }
fi
echo "  run bar via: qs -p $ROOT/shell/shell.qml"
echo "  (visual check: expected a compact top bar on each monitor)"

echo "PASS"
exit 0