# Jeri Desktop

A compact, modern, low-resource Hyprland desktop shell for Arch Linux, built on Quickshell/QML. Working name: **Jeri Desktop**.

Independent of Caelestia. Uses its own `jeri-desktop` XDG namespace. Official-repo dependencies only (no AUR).

> Minimal at rest. Alive in motion. Invisible until needed.

## Status

**Phase: Bootstrap (Part 1).** Minimal shell running: compact top bar per monitor, live workspaces from Hyprland IPC, clock (Event-driven), memory state, clean exit. Architecture, isolation, installer, uninstaller, doctor, dry-run, and Docker validation in place.

## Highlights

- Single-process Quickshell shell — no daemons, no polling loops.
- Hyprland data via IPC sockets (`Quickshell.Hyprland`), clock at minute precision (`Quickshell.SystemClock`).
- Full/Balanced/Lite visual modes + reduced motion via one `Motion` singleton (Part 2 UI).
- Transactional, reversible installer with per-file sha256 manifest and backup/restore.
- Caelestia-safe: separate namespace, reversible one-line Hyprland include, hash-guarded uninstall.

## Quick start

```sh
./doctor.sh            # preflight (read-only)
./install.sh --dry-run # plan only
./install.sh           # deps (sudo pacman) + files
~/.local/share/jeri-desktop/bin/jeri   # run the shell
```

## Docs

- [Architecture](docs/ARCHITECTURE.md)
- [Install & recovery](docs/INSTALL.md)
- [Known limitations](docs/KNOWN_LIMITATIONS.md)

## Layout

```text
Dockerfile  compose.yaml            static validation env
install.sh  uninstall.sh  doctor.sh  dry-run.sh   host lifecycle
dependency-manifest.yaml            dependency list (official repos)
config/   shell/   lua/   scripts/   tests/   docs/
```

## License

MIT — see [LICENSE](LICENSE).