#!/bin/sh




set -u
ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
PASS=0; FAIL=0; SKIP=0

run_test() {
    name="$1" script="$2"
    printf '%-44s' "$name"
    if [ ! -r "$script" ]; then
        echo "SKIP (missing)"
        SKIP=$((SKIP+1)); return 0
    fi
    out="$(sh "$script" 2>&1)"
    rc=$?
    if [ $rc -eq 0 ]; then
        echo "PASS"; PASS=$((PASS+1))
    else
        echo "FAIL (rc=$rc)"
        printf '%s\n' "$out" | sed 's/^/    /' | head -20
        FAIL=$((FAIL+1))
    fi
}

printf -- '--- Jeri Desktop test suite ---\n\n'

printf 'Shell syntax:\n'
for f in install.sh uninstall.sh doctor.sh dry-run.sh installer/lib.sh tests/run.sh; do
    printf '%-44s' "bash -n $f"
    if bash -n "$ROOT/$f" 2>/dev/null; then echo "PASS"; PASS=$((PASS+1)); else echo "FAIL"; FAIL=$((FAIL+1)); fi
done
if [ -x /usr/bin/luac ]; then
    run_test "luac -p lua/gen-conf.lua"  "$ROOT/tests/unit/lua_syntax.sh"
else echo "  (luac skipped)"; SKIP=$((SKIP+1)); fi
printf '\n'

printf 'Config generation:\n'
run_test "gen-conf golden match" "$ROOT/tests/unit/gen_conf_golden.sh"
printf '\n'

printf 'Static analysis:\n'
if [ -x /usr/bin/shellcheck ]; then
    run_test "shellcheck (all scripts)" "$ROOT/tests/unit/shellcheck.sh"
else echo "  (shellcheck skipped)"; SKIP=$((SKIP+1)); fi
if [ -x /usr/bin/qmllint ]; then
    run_test "qmllint shell.qml" "$ROOT/tests/unit/qmllint.sh"
else echo "  (qmllint skipped)"; SKIP=$((SKIP+1)); fi
printf '\n'

printf 'Installer sandbox tests:\n'
run_test "round-trip install/uninstall" "$ROOT/tests/installer/test_roundtrip.sh"
run_test "marker + strip round-trip"    "$ROOT/tests/installer/test_marker_strip.sh"
run_test "hash-mismatch safety"         "$ROOT/tests/installer/test_hash_guard.sh"
run_test "rollback on mid-install fail" "$ROOT/tests/installer/test_rollback.sh"
printf '\n'

printf 'Manifest consistency:\n'
run_test "runtime packages parseable" "$ROOT/tests/unit/manifest_sync.sh"
printf '\n'

printf -- '--- results: %s passed, %s failed, %s skipped ---\n' "$PASS" "$FAIL" "$SKIP"
[ "$FAIL" -eq 0 ]