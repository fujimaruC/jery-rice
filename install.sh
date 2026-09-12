#!/bin/sh



set -u
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
. "$SCRIPT_DIR/installer/lib.sh"

DRY_RUN=0; CHECK_ONLY=0; YES=0; INSTALL_PKGS=1; VERBOSE=0; JERI_ROOT=""
while [ $# -gt 0 ]; do
    case "$1" in
        --dry-run)   DRY_RUN=1; JERI_DRY_RUN=1 ;;
        --check)     CHECK_ONLY=1 ;;
        --yes|-y)    YES=1 ;;
        --no-packages) INSTALL_PKGS=0 ;;
        --root)      shift; JERI_ROOT="${1:?--root requires a directory}" ;;
        --verbose|-v) VERBOSE=1 ;;
        -h|--help)   head -18 "$0" | tail -17; exit 0 ;;
        *)           die "unknown option: $1" ;;
    esac
    shift
done

resolve_dirs
[ $DRY_RUN -eq 1 ] && JERI_DRY_RUN=1
mkdir_p "$JERI_STATE_HOME/logs" 2>/dev/null || true
exec > >(tee -a "$JERI_INSTALL_LOG") 2>&1 || true
trap 'rollback_pending; exit 1' ERR


log "Jeri Desktop installer"

if ! require_arch_linux; then
    warn "not Arch Linux (required for package operations). Package install will be skipped."
    INSTALL_PKGS=0
fi

if ! require_host_arch; then
    die "unsupported architecture $(uname -m)"
fi

[ $JERI_SANDBOX -eq 1 ] || check_disk_space 500000 "$HOME" \
    || die "insufficient disk space on $HOME (need 500 MB free)"

if detect_caelestia; then
    log "Caelestia detected at $(detect_caelestia) — will NOT touch or require it."
fi


pkg_list=""
if [ "$INSTALL_PKGS" -eq 1 ]; then
    log "checking runtime dependencies"
    if ! pkg_list="$(list_missing_runtime)"; then
        die "dependency resolution failed — install aborted (no changes made)."
    fi
    log "missing runtime packages: ${pkg_list:-(none)}"
fi

if [ "$CHECK_ONLY" -eq 1 ]; then
    log "check passed (no changes written)."
    [ -n "$pkg_list" ] && warn "missing packages to install: $pkg_list"
    exit 0
fi

if [ $DRY_RUN -eq 1 ]; then
    log "dry-run: would perform the following."
    [ -n "$pkg_list" ] && log "  pacman -S $pkg_list"
    log "  copy  shell/ -> $JERI_CONFIG_HOME/shell/"
    log "  copy  shell/shell.qml -> $JERI_CONFIG_HOME/shell.qml"
    log "  copy  config/ -> $JERI_CONFIG_HOME/config/"
    log "  write $JERI_WRAPPER_DST"
    log "  write $JERI_SESSION_DST"
    log "  copy  lua/ -> $JERI_CONFIG_HOME/lua/"
    log "  write $JERI_MANIFEST"
    log "  source $JERI_INJECT_DST in $JERI_HYPR_CONF"
    log "Done (dry-run, no changes made)."
    exit 0
fi


if [ "$INSTALL_PKGS" -eq 1 ] && [ -n "$pkg_list" ]; then
    log "installing dependencies"
    printf '%s\n' "$pkg_list" | install_packages
fi


: > "$JERI_PENDING"
trap 'rollback_pending; exit 1' ERR

log "installing configuration to $JERI_CONFIG_HOME"
install_tree "$SCRIPT_DIR/shell" "$JERI_CONFIG_HOME/shell"
install_tree "$SCRIPT_DIR/config" "$JERI_CONFIG_HOME/config"
install_tree "$SCRIPT_DIR/lua"    "$JERI_CONFIG_HOME/lua"
[ -d "$SCRIPT_DIR/assets" ] && install_tree "$SCRIPT_DIR/assets" "$JERI_DATA_HOME/assets"

log "generating Hyprland include config"
lua "$JERI_CONFIG_HOME/lua/gen-conf.lua" -o "$JERI_INJECT_DST"
printf '%s\n' "$JERI_INJECT_DST" >> "$JERI_PENDING"

write_wrapper
write_session_entry


manifest_init

{
    while IFS= read -r p; do
        [ -n "$p" ] || continue
        realpath -m "$p"
    done < "$JERI_PENDING"
} | sort -u > "$JERI_PENDING.tmp"
mv "$JERI_PENDING.tmp" "$JERI_PENDING"

while IFS= read -r p; do
    [ -n "$p" ] || continue
    manifest_add "$p"
done < "$JERI_PENDING"
rm -f "$JERI_PENDING"
log "file manifest written to $JERI_MANIFEST"


hyprland_integrate


if [ $JERI_SANDBOX -eq 0 ] && verify_shell_qml; then
    log "qmllint passed on $JERI_CONFIG_HOME/shell.qml"
fi

log "Install complete."
log "Launcher:  $JERI_WRAPPER_DST"
log "Uninstall: $SCRIPT_DIR/uninstall.sh"