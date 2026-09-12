# Jeri Desktop — Install & Recovery

## Installation (fresh Arch)

Everything comes from the **official Arch `extra` repository** (including `quickshell` since 0.3.1). No AUR.

```sh
git clone <this repo> jeri-desktop
cd jeri-desktop
./doctor.sh            # read-only preflight
./install.sh --dry-run # what would happen, no changes
./install.sh           # install dependencies (sudo pacman) + files
```

The installer:

1. Verifies Arch Linux (`ID=arch`) and `uname -m`.
2. Checks ≥500 MB free.
3. Detects a previous/Caelestia install (Caelestia: read-only notice only).
4. Resolves runtime dependencies with `pacman -Si`; aborts if any package is unknown (never silently substitutes).
5. Installs only missing packages (`pacman --needed -S`).
6. Copies config into the `jeri-desktop` namespace, generates `config/hypr/jeri-inject.conf`.
7. Appends **one marker line** (`source = … # jeri-desktop`) to `~/.config/hypr/hyprland.conf` if present.
8. Writes a manifest of every installed file (sha256).

## Run

```sh
~/.local/share/jeri-desktop/bin/jeri        # wrapper: qs --no-duplicate -p ~/.config/jeri-desktop/shell.qml
```

## Removal

```sh
./uninstall.sh          # interactive consent; remove only manifest-tracked files
./uninstall.sh --yes --purge   # also drop backups/logs
```

- Files you modified are **left in place** (hash mismatch → refuse). Everything else tracked by the manifest is removed.
- The `# jeri-desktop` marker line(s) in `hyprland.conf` are stripped.
- `~/.config/caelestia/` is never touched.

## Rollback / restore

Try `./install.sh` again only when you are sure the failure cause was fixed. For a failed install the installer already rolls back (removes what it created, keeps logs in `~/.local/state/jeri-desktop/logs/`).

Restore a pre-existing file that an install overwrote (e.g., your `hyprland.conf`):

```sh
./uninstall.sh --restore
```

restores every snapshot recorded in `~/.local/state/jeri-desktop/backup/index.lst`.

## Docker (static validation)

```sh
docker compose up validate     # shellcheck + luac + qmllint + gen-conf golden + installer sandbox tests
```

The container mounts only this repo and a sandboxed HOME. It never mounts `~/.config`, `~/.ssh`, `~/.gnupg`, and **cannot** validate a real Hyprland/Wayland session — runtime integration must be tested in a host Hyprland session.

## Coexistence with Caelestia

- Separate namespace: `jeri-desktop/*`.
- Jeri keybinds live only in its injected include; conflicts are reported but never auto-merged.
- Uninstalling Jeri never edits, removes, or reads Caelestia files.

## Troubleshooting

| Symptom | Action |
|---|---|
| `install.sh` aborts on a package | verify the package name with `pacman -Si <pkg>`; report the manifest entry |
| shell won't start | `qmllint ~/.config/jeri-desktop/shell/shell.qml`; check `~/.local/state/jeri-desktop/logs/` |
| marker not removed | remove the `# jeri-desktop` lines manually from `hyprland.conf` (they are self-labelled) |
| clash with other keybind | unbind in `config/jeri/jeri.json` and regenerate (`lua lua/gen-conf.lua …`) |