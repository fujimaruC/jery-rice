#!/bin/sh




ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
[ -n "${WAYLAND_DISPLAY:-}" ] || { echo "no wayland session — bench skipped"; exit 2; }
command -v qs >/dev/null || { echo "quickshell not found"; exit 2; }

start="$(date +%s%N)"
timeout 15 qs -p "$ROOT/tests/fixtures/smoke" 2>/dev/null
rc=$?
end="$(date +%s%N)"
ms=$(( (end - start) / 1000000 ))

echo "startup-to-exit: ${ms}ms (expected ~1500ms self-quit), rc=${rc}"
[ "$rc" -eq 0 ]