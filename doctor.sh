#!/bin/sh




set -u
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
. "$SCRIPT_DIR/installer/lib.sh"

JERI_ROOT=""
while [ $# -gt 0 ]; do
    case "$1" in
        --root) shift; JERI_ROOT="${1:?--root requires a directory}" ;;
        *) die "unknown option: $1" ;;
    esac
    shift
done

resolve_dirs

WARN=0 ERR=0
pass() { printf '  [ok] %s\n' "$*"; }
fail() { ERR=$((ERR+1)); printf '  [!!] %s\n' "$*"; }
warn_check() { WARN=$((WARN+1)); printf '  [~]  %s\n' "$*"; }

printf '--- Jeri Desktop Doctor ---\n\n'


printf 'Environment:\n'
require_arch_linux && pass "Arch Linux" || warn_check "not Arch Linux"
require_host_arch && pass "architecture $(uname -m)" || fail "unsupported arch"
command -v qs >/dev/null && pass "quickshell $(qs --version 2>&1 | head -1)" || warn_check "quickshell not in PATH"
command -v hyprctl >/dev/null && pass "hyprctl" || warn_check "hyprctl not in PATH"
printf '\n'


printf 'Namespace:\n'
[ -d "$JERI_CONFIG_HOME" ] && pass "$JERI_CONFIG_HOME" || warn_check "$JERI_CONFIG_HOME missing"
[ -d "$JERI_DATA_HOME" ]   && pass "$JERI_DATA_HOME"   || warn_check "$JERI_DATA_HOME missing"
[ -d "$JERI_STATE_HOME" ]  && pass "$JERI_STATE_HOME"  || warn_check "$JERI_STATE_HOME missing"
printf '\n'


printf 'Manifest:\n'
[ -f "$JERI_MANIFEST" ] && pass "$JERI_MANIFEST" || warn_check "no manifest — not installed or incomplete"
printf '\n'


printf 'Config:\n'
if [ -f "$JERI_CONFIG_HOME/shell.qml" ]; then
    pass "shell.qml exists"
    command -v qmllint >/dev/null && {
        qmllint "$JERI_CONFIG_HOME/shell.qml" >/dev/null 2>&1 \
            && pass "qmllint shell.qml" || warn_check "qmllint errors in shell.qml"
    }
else
    warn_check "shell.qml not found"
fi

if [ -f "$JERI_CONFIG_HOME/config/jeri/jeri.json" ]; then
    if command -v jq >/dev/null; then
        jq -e . "$JERI_CONFIG_HOME/config/jeri/jeri.json" >/dev/null 2>&1 \
            && pass "jeri.json valid JSON" || fail "jeri.json invalid JSON"
    else
        warn_check "jq not installed — cannot validate jeri.json"
    fi
else
    warn_check "jeri.json not found"
fi
printf '\n'


printf 'Integration:\n'
if [ -f "$JERI_HYPR_CONF" ] && grep -q ' # jeri-desktop$' "$JERI_HYPR_CONF"; then
    pass "hyprland include marker present in $JERI_HYPR_CONF"
elif [ -f "$JERI_HYPR_CONF" ]; then
    warn_check "hyprland marker NOT found in $JERI_HYPR_CONF"
else
    warn_check "$JERI_HYPR_CONF not found"
fi
printf '\n'


if detect_caelestia >/dev/null 2>&1; then
    warn_check "Caelestia detected at $(detect_caelestia) — coexistence active (no conflict expected)"
fi

if [ "$ERR" -gt 0 ]; then
    printf '\n%s errors, %s warnings.\n' "$ERR" "$WARN"
    exit 1
elif [ "$WARN" -gt 0 ]; then
    printf '\n0 errors, %s warnings.\n' "$WARN"
    exit 0
else
    printf '\nAll checks passed.\n'
    exit 0
fi