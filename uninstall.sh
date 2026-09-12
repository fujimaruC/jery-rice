#!/bin/sh



set -u
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
. "$SCRIPT_DIR/installer/lib.sh"

DRY_RUN=0; YES=0; RESTORE=0; PURGE=0
while [ $# -gt 0 ]; do
    case "$1" in
        --dry-run)  DRY_RUN=1; JERI_DRY_RUN=1 ;;
        --yes|-y)   YES=1 ;;
        --restore)  RESTORE=1 ;;
        --purge)    PURGE=1 ;;
        --root)     shift; JERI_ROOT="${1:?--root requires a directory}" ;;
        -h|--help)  sed -n '3,11p' "$0"; exit 0 ;;
        *)          die "unknown option: $1" ;;
    esac
    shift
done

resolve_dirs

if [ ! -f "$JERI_MANIFEST" ]; then
    die "no Jeri Desktop installation detected at $JERI_CONFIG_HOME (manifest not found)."
fi

if [ "$YES" -ne 1 ]; then
    printf 'This will remove Jeri Desktop files tracked in %s.\n' "$JERI_MANIFEST"
    printf 'Caelestia and all non-Jeri files will NOT be affected.\n'
    printf 'Proceed? [y/N] '
    read -r answer
    case "$answer" in y|Y|yes|YES) ;; *) exit 1 ;; esac
fi

log "Jeri Desktop uninstaller"


if [ "$RESTORE" -eq 1 ]; then
    if [ ! -f "$JERI_BACKUP_DIR/index.lst" ]; then
        die "no backup index found under $JERI_BACKUP_DIR"
    fi
    log "restoring snapshot files"
    restore_backup_files
    log "Restore complete."
    exit 0
fi


log "removing tracked files"
while IFS=$'\t' read -r hash relpath; do
    [ -n "$relpath" ] || continue
    if [ "$DRY_RUN" -eq 1 ]; then
        printf '  would remove  %s\n' "$relpath"
        continue
    fi
    if [ ! -f "$relpath" ] && [ ! -L "$relpath" ]; then
        warn "missing (skip): $relpath"
        continue
    fi

    if ! check_hash "$relpath"; then
        err "hash mismatch (modified by user?): $relpath — leaving in place"
        continue
    fi
    rm -f -- "$relpath" && printf '  removed %s\n' "$relpath"
done < "$JERI_MANIFEST"


for d in "$JERI_STATE_HOME" "$JERI_CACHE_HOME" "$JERI_DATA_HOME/bin" "$JERI_CONFIG_HOME"; do
    [ -d "$d" ] && rmdir "$d" 2>/dev/null || true
done
[ -d "$JERI_CONFIG_HOME" ] && warn "non-empty directory: $JERI_CONFIG_HOME (contents left for your safety)"


if [ "$DRY_RUN" -eq 1 ]; then
    log "hyprland integration: would strip marker"
else
    hyprland_unintegrate
fi



if [ "$DRY_RUN" -eq 0 ]; then
    rm -f -- "$JERI_MANIFEST" "$JERI_PENDING"
    [ "$PURGE" -eq 1 ] && rm -rf -- "$JERI_STATE_HOME" "$JERI_CACHE_HOME"
    rm -rf -- "$JERI_DATA_HOME/bin" "$JERI_DATA_HOME/applications" 2>/dev/null || true
fi

log "Uninstall complete. Caelestia remains untouched."