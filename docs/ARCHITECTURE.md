# Jeri Desktop — Architecture

Jeri Desktop is a zero-polling, single-process Quickshell-based shell for Hyprland on Arch Linux. It is fully isolated from Caelestia and uses its own `jeri-desktop` XDG namespace.

## Layers

```text
┌──────────────────────────────────────────────────────────┐
│ Layer 4  install.sh / uninstall.sh / doctor.sh / dry-run   │  POSIX sh + pacman (official repos only)
├──────────────────────────────────────────────────────────┤
│ Layer 3  quickshell (one process) — QML UI + services      │
│          Quickshell.Hyprland._Ipc | Services.* | Io        │
├──────────────────────────────────────────────────────────┤
│ Layer 2  Hyprland compositor (IPC sockets, wlr-layer-shell)│
├──────────────────────────────────────────────────────────┤
│ Layer 1  Arch packages (hyprland, quickshell, pipewire…)   │
└──────────────────────────────────────────────────────────┘
```

## Design rules

- **Single process.** The whole shell runs in one `quickshell` process. No daemons, no watchers, no per-feature helpers.
- **Event-driven.** Hyprland data flows through `Quickshell.Hyprland.Hyprland` (event socket); UTC clock via `Quickshell.SystemClock` (minute precision). Off/closed panels do zero work.
- **Design tokens.** One `theme/` set (Colors, Typography, Metrics, Motion, Effects) consumed by every component.
- **Motion gating.** `Motion.visualMode` (Full/Balanced/Lite) + `Motion.reducedMotion` gate all durations and expensive effects.
- **Isolation.** All writes live under `~/.config/jeri-desktop`, `~/.local/share/jeri-desktop`, `~/.cache/jeri-desktop`, `~/.local/state/jeri-desktop`. Hyprland integration = one reversible marker line in the user's `hyprland.conf`.

## Repository layout

```text
ricе-j/                    (working name: Jeri Desktop)
├── Dockerfile  compose.yaml    isolated static-validation container
├── install.sh  uninstall.sh  doctor.sh  dry-run.sh   host lifecycle
├── installer/lib.sh            shared installer logic + rollback
├── dependency-manifest.yaml    machine-readable dependency list
├── config/
│   ├── hypr/jeri-inject.conf   generated, reversible Hyprland include
│   └── jeri/jeri.json          user configuration defaults
├── shell/
│   ├── shell.qml               entry (qs -p …)
│   ├── theme/                  design tokens (singletons)
│   ├── services/               HyprlandService, SystemService
│   ├── components/             reusable primitives
│   └── modules/                Bar (one per monitor)
├── lua/gen-conf.lua            auxiliary config generator (only Lua use)
├── scripts/bench.sh
├── tests/                      unit + installer sandbox + fixtures
└── docs/
```

## Lifecycle

| Tool | What it does |
|---|---|
| `install.sh` | verify Arch/arch/disk → resolve deps (`pacman -Si`) → transactional copy → generate include → marker line → manifest |
| `uninstall.sh` | remove only manifest-tracked files; hash-verify before delete; strip marker; keep backup |
| `doctor.sh`   | read-only health checks (deps, namespaces, config JSON, marker, qmllint) |
| `dry-run.sh`  | `install.sh --dry-run` |
| Docker        | static checks only: shellcheck, luac, qmllint, gen-conf golden, installer sandbox tests (never estimates a real Wayland session) |

## Bootstrap milestone (Part 1 gate)

Passing state: Quickshell starts → compact top bar on every monitor → workspaces from Hyprland IPC → clock (SystemClock) → memory state → clean exit. Verified live, then locked in Docker-validated tests.

`ponytail:` comments mark deliberate ceilings and their upgrade path.