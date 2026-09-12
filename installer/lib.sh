#!/bin/sh



set -u

JERI_BRAND="jeri-desktop"
JERI_REPO_ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
JERI_MANIFEST_YAML="$JERI_REPO_ROOT/dependency-manifest.yaml"


TC=''
TW=''
TR=''
if [ -t 1 ] && command -v tput >/dev/null 2>&1; then
    TC="$(tput setaf 6 2>/dev/null || true)"
    TW="$(tput setaf 3 2>/dev/null || true)"
    TR="$(tput sgr0 2>/dev/null || true)"
fi

log()   { printf '%s[*]%s %s\n' "$TC" "$TR" "$*"; }
warn()  { printf '%s[!]%s %s\n' "$TW" "$TR" "$*" >&2; }
die()   { printf 'FATAL: %s\n' "$*" >&2; exit 1; }
err()   { printf '  [X] %s\n' "$*" >&2; }




resolve_dirs() {
    : "${XDG_CONFIG_HOME:=$HOME/.config}"
    : "${XDG_DATA_HOME:=$HOME/.local/share}"
    : "${XDG_STATE_HOME:=$HOME/.local/state}"
    : "${XDG_CACHE_HOME:=$HOME/.cache}"

    if [ -n "${JERI_ROOT:-}" ]; then

        JERI_CONFIG_HOME="$JERI_ROOT/config/home/.config/jeri-desktop"
        JERI_DATA_HOME="$JERI_ROOT/config/home/.local/share/jeri-desktop"
        JERI_STATE_HOME="$JERI_ROOT/state/jeri-desktop"
        JERI_CACHE_HOME="$JERI_ROOT/cache/jeri-desktop"
        JERI_HYPR_CONF="$JERI_ROOT/home/.config/hypr/hyprland.conf"
        JERI_SANDBOX=1
    else
        JERI_CONFIG_HOME="$XDG_CONFIG_HOME/$JERI_BRAND"
        JERI_DATA_HOME="$XDG_DATA_HOME/$JERI_BRAND"
        JERI_STATE_HOME="$XDG_STATE_HOME/$JERI_BRAND"
        JERI_CACHE_HOME="$XDG_CACHE_HOME/$JERI_BRAND"
        JERI_HYPR_CONF="${XDG_CONFIG_HOME}/hypr/hyprland.conf"
        JERI_SANDBOX=0
    fi

    JERI_MANIFEST="$JERI_STATE_HOME/manifest.lst"
    JERI_BACKUP_DIR="$JERI_STATE_HOME/backup"
    JERI_PENDING="$JERI_STATE_HOME/.pending.lst"
    JERI_INSTALL_LOG="$JERI_STATE_HOME/logs/install.log"
    JERI_INJECT_SRC="$JERI_REPO_ROOT/config/hypr/jeri-inject.conf"
    JERI_INJECT_DST="$JERI_CONFIG_HOME/config/hypr/jeri-inject.conf"
    JERI_WRAPPER_DST="$JERI_DATA_HOME/bin/jeri"
    JERI_SESSION_DST="$JERI_DATA_HOME/applications/jeri-desktop.desktop"
}

mkdir_p() { mkdir -p "$1" || die "cannot create $1"; }

require_arch_linux() {
    [ -f /etc/os-release ] || return 1
    awk -F= '/^ID=/{gsub(/"/,"",$2); print $2}' /etc/os-release | grep -qx 'arch'
}

require_host_arch() {
    case "$(uname -m)" in
        x86_64|aarch64) return 0 ;;
        *) return 1 ;;
    esac
}

check_disk_space() {
    local need="$1" target="$2"
    local avail
    avail="$(df -Pk "$target" 2>/dev/null | awk 'NR==2{print $4}')"
    [ -n "$avail" ] && [ "$avail" -ge "$need" ] 2>/dev/null
}


detect_caelestia() {
    local d="$HOME/.config/caelestia"
    [ -d "$d" ] || return 1
    printf '%s' "$d"
}

assert_isolated_dir() {
    case "$1" in
        "$JERI_CONFIG_HOME"/*|"$JERI_DATA_HOME"/*|"$JERI_STATE_HOME"/*|"$JERI_CACHE_HOME"/*)
            return 0 ;;
        *)
            die "refusing to touch path outside Jeri namespace: $1" ;;
    esac
}


yaml_pkgs() {
    sed -n "/^$1:/,/^[a-z_]*:/p" "$JERI_MANIFEST_YAML" \
        | grep -E '^  - ' \
        | sed 's/^  - *//; s/ *#.*$//' \
        | grep -v '^[[:space:]]*$'
}

pkg_available() { pacman -Si "$1" >/dev/null 2>&1; }
pkg_installed() { pacman -Qi "$1" >/dev/null 2>&1; }


list_missing_runtime() {
    local p missing=0
    for p in $(yaml_pkgs runtime); do
        if ! pkg_installed "$p"; then
            if ! pkg_available "$p"; then
                err "package '$p' NOT found in official Arch repositories"
                missing=1
            else
                printf '%s\n' "$p"
            fi
        fi
    done
    [ "$missing" -eq 0 ]
}

install_packages() {
    local pkgs
    pkgs="$(cat)"
    [ -z "$pkgs" ] && { log "all runtime dependencies already present."; return 0; }
    log "installing missing dependencies:"
    printf '%s\n' "$pkgs" | sed 's/^/    /'
    if command -v sudo >/dev/null 2>&1; then
        sudo pacman --needed --noconfirm -S $pkgs
    elif [ "$(id -u)" -eq 0 ]; then
        pacman --needed --noconfirm -S $pkgs
    else
        die "root is required to install packages (run with sudo / as root)"
    fi
}


manifest_init() {
    mkdir_p "$JERI_STATE_HOME"
    [ -f "$JERI_MANIFEST" ] || : > "$JERI_MANIFEST"
}

manifest_add() {
    check_hash "${1#./}"
    printf '%s\t%s\n' "$(sha256sum "$1" | cut -d' ' -f1)" "${1#./}" >> "$JERI_MANIFEST"
}

check_hash() {
    local rel="$1" want got
    want="$(awk -F"\t" -v r="$rel" '$2==r{print $1}' "$JERI_MANIFEST")"
    [ -n "$want" ] || return 2
    got="$(sha256sum "$rel" | cut -d' ' -f1)"
    [ "$want" = "$got" ]
}


manrel() {
    local base="$1" abs
    abs="$(CDPATH= cd -- "$base" && pwd)"
    if [ "$abs" = "${abs#"$JERI_CONFIG_HOME"/}" ] \
        && [ "$abs" = "${abs#"$JERI_DATA_HOME"/}" ] \
        && [ "$abs" = "${abs#"$JERI_STATE_HOME"/}" ] \
        && [ "$abs" = "${abs#"$JERI_CACHE_HOME"/}" ]; then
        printf '%s' "$abs"
    else
        printf '%s' "${abs#$(dirname "$abs")/}"
    fi
}

backup_file() {
    [ -f "$1" ] || return 0
    mkdir_p "$JERI_BACKUP_DIR"
    local idx="$JERI_BACKUP_DIR/index.lst"
    [ -f "$idx" ] || : > "$idx"
    local n
    n="$(wc -l < "$idx" | tr -d ' ')"
    n=$((n + 1))
    local bkp="$JERI_BACKUP_DIR/$(printf '%04d' "$n").bak"
    cp -p "$1" "$bkp" || warn "backup failed for $1"
    printf '%s\t%s\n' "$1" "$bkp" >> "$idx"
}

restore_backup_files() {
    local idx="$JERI_BACKUP_DIR/index.lst"
    [ -f "$idx" ] || die "no backup index found"
    while IFS=$'\t' read -r orig bkp; do
        [ -n "$orig" ] || continue
        mkdir_p "$(dirname "$orig")"
        cp -p "$bkp" "$orig" && log "restored $orig"
    done < "$idx"
}


install_tree() {
    local src="$1" dst="$2"
    assert_isolated_dir "$dst"
    [ -d "$src" ] || die "missing source tree: $src"
    [ -d "$dst" ] || mkdir_p "$dst"
    ( CDPATH= cd "$src" && find . -type f ) | while read -r f; do
        mkdir_p "$(dirname "$dst/$f")"
        backup_file "$dst/$f"
        cp -p "$src/$f" "$dst/$f" || { printf '  failed to copy: %s\n' "$f" >&2; exit 1; }
        printf '%s\n' "$dst/$f" >> "$JERI_PENDING"
    done || return 1
}


hyprland_integrate() {
    [ -f "$JERI_HYPR_CONF" ] || { log "no $JERI_HYPR_CONF — skipping injection (add manually: source = $JERI_INJECT_DST)"; return 0; }
    if grep -q ' # jeri-desktop$' "$JERI_HYPR_CONF"; then
        log "Jeri include marker already present in $JERI_HYPR_CONF"
        return 0
    fi
    printf '\n# jeri-desktop\nsource = %s # jeri-desktop\n' "$JERI_INJECT_DST" >> "$JERI_HYPR_CONF"
    log "appended marker line to $JERI_HYPR_CONF"
}

hyprland_unintegrate() {
    [ -f "$JERI_HYPR_CONF" ] || return 0
    if grep -q ' # jeri-desktop$' "$JERI_HYPR_CONF"; then
        if [ "${JERI_DRY_RUN:-0}" = 1 ]; then
            echo "  would strip '# jeri-desktop' marker line from $JERI_HYPR_CONF"
            return 0
        fi
        backup_file "$JERI_HYPR_CONF"
        grep -vE '(^# jeri-desktop$| # jeri-desktop$)' "$JERI_HYPR_CONF" > "$JERI_HYPR_CONF.tmp" \
            && mv "$JERI_HYPR_CONF.tmp" "$JERI_HYPR_CONF"
        log "stripped Jeri marker line from $JERI_HYPR_CONF"
    fi
}


write_wrapper() {
    local w="$JERI_WRAPPER_DST"
    mkdir_p "$(dirname "$w")"
    backup_file "$w"
    cat > "$w" <<EOF
#!/bin/sh
JERI_CONFIG_HOME="\${XDG_CONFIG_HOME:-\$HOME/.config}/$JERI_BRAND"
exec qs --no-duplicate -p "\$JERI_CONFIG_HOME/shell.qml" "\$@"
EOF
    chmod +x "$w"
    printf '%s\n' "$w" >> "$JERI_PENDING"
}

write_session_entry() {
    local d="$JERI_SESSION_DST"
    mkdir_p "$(dirname "$d")"
    backup_file "$d"
    cat > "$d" <<EOF
[Desktop Entry]
Type=Application
Version=1.0
Name=Jeri Desktop
Comment=Jeri Desktop shell (isolated, quickshell)
Exec=$JERI_WRAPPER_DST
X-GNOME-Autostart-enabled=false
EOF
    printf '%s\n' "$d" >> "$JERI_PENDING"
}


rollback_pending() {
    [ -f "$JERI_PENDING" ] || return 0
    warn "installation incomplete — rolling back"

    while IFS= read -r p; do
        [ -n "$p" ] || continue
        case "$p" in
            "$JERI_CONFIG_HOME"/*|"$JERI_DATA_HOME"/*|"$JERI_STATE_HOME"/*|"$JERI_CACHE_HOME"/*)
                [ -e "$p" ] && rm -f -- "$p" ;;
        esac
    done < <(tac "$JERI_PENDING")
    rm -f "$JERI_PENDING"
    [ -f "$JERI_MANIFEST" ] && [ ! -s "$JERI_MANIFEST" ] && rm -f "$JERI_MANIFEST"
    warn "rolled back. Logs preserved under $JERI_STATE_HOME/logs"
}

verify_shell_qml() {
    command -v qmllint >/dev/null 2>&1 || return 0
    qmllint "$JERI_CONFIG_HOME/shell.qml" >/dev/null 2>&1
}