# Part 1/3 — Architecture, Isolation & Bootstrap Specification

## Mission

Build a completely independent, modern Hyprland desktop environment from scratch for Arch Linux.

Working name: **Jeri Desktop**.

The visual target is inspired by the supplied reference screenshot: a compact, polished dashboard/control-center experience with rounded surfaces, subtle translucency, clean typography, compact information density, workspaces, system information, calendar, and an integrated media player.

Do NOT clone Caelestia. Treat Caelestia only as a quality benchmark.

The goal is:

> Caelestia-like polish, substantially lighter architecture, tighter information density, fewer unnecessary dependencies, and a more coherent design system.

The target hardware includes older Intel integrated graphics such as Intel HD 4000, so performance is a first-class requirement.

---

## Non-negotiable isolation requirement

The user currently has Caelestia installed.

NEVER overwrite, modify, delete, rename, or depend on Caelestia configuration.

The project must have its own namespace, for example:

- `~/.config/jeri-desktop/`
- `~/.local/share/jeri-desktop/`
- `~/.cache/jeri-desktop/`
- `~/.local/state/jeri-desktop/`

Never write project files into:

- `~/.config/caelestia/`
- Caelestia-managed files
- unrelated Hyprland configuration files

Use explicit XDG paths.

For development and build validation, create a Docker environment so dependencies and project tooling are isolated from the user's host system.

Important: Docker is the isolated development/build environment. Do not pretend that a normal Docker container can safely replace the host Wayland/Hyprland session. Runtime integration must remain host-side and must be installed into the Jeri Desktop namespace only.

Provide:

1. `Dockerfile`
2. `docker-compose.yml` or equivalent build configuration
3. reproducible build/test commands
4. a host-side installer/uninstaller
5. a dry-run mode
6. backup/rollback behavior for ONLY files owned by Jeri Desktop

---

## Fresh Arch requirement

The project must be installable on a clean, current Arch Linux installation.

Before installing anything:

1. Detect architecture.
2. Detect whether the machine is actually Arch Linux.
3. Detect Wayland/Hyprland availability.
4. Detect installed packages.
5. Check repository availability using Arch package tools.
6. Prefer official Arch repositories.
7. Only use AUR when there is a real requirement that cannot reasonably be satisfied by official packages.
8. Verify package names before installation.
9. Never invent package names.
10. Fail clearly instead of silently substituting an incompatible package.

The installer must install every runtime dependency required by the project.

Do not assume the user already has:

- Quickshell
- Hyprland
- a launcher
- notification daemon
- audio stack
- networking tools
- screenshot utilities
- fonts
- icon packages
- media controls
- brightness controls

Detect what is needed and install only what is actually required.

---

## Technology rules

### Desktop compositor

Use:

- Hyprland
- Wayland-native applications wherever practical

### Shell UI

Use:

- **Quickshell**
- QML for the Quickshell UI

Important technical constraint:

**Quickshell is QML-based. Do not try to force Lua into the Quickshell UI.**

Use Lua where it is technically appropriate for auxiliary configuration, generation, helper tooling, or user-customizable data, but keep the actual Quickshell interface in QML.

Do not invent a fake Lua-based Quickshell architecture.

### Configuration

Use clear, modular configuration.

Prefer:

- QML for UI
- Hyprland config for compositor behavior
- Lua for optional auxiliary configuration/data tooling
- shell scripts only where appropriate
- CSS only when a specific external component actually requires it

Avoid unnecessary programming languages.

---

## Performance requirements

Target older hardware.

The UI must:

- avoid constant high-frequency polling
- use event-driven updates whenever possible
- stop or reduce animations when idle
- avoid unnecessary blur
- avoid excessive shadows
- avoid huge transparent surfaces
- avoid Electron
- avoid web-based desktop shells
- avoid permanently running heavy background services
- avoid unnecessary Python daemons
- avoid duplicate system-monitoring processes
- avoid polling every second when an event/API can be used
- avoid memory-heavy frameworks for simple UI tasks

Every service must have a reason to exist.

Every dependency must have a reason to exist.

---

## Project structure

Create a maintainable repository approximately like:

```text
jeri-desktop/
├── docker/
│   ├── Dockerfile
│   └── compose.yaml
├── installer/
│   ├── install.sh
│   ├── uninstall.sh
│   ├── doctor.sh
│   └── dry-run.sh
├── config/
│   ├── hypr/
│   └── jeri/
├── shell/
│   ├── shell.qml
│   ├── components/
│   ├── modules/
│   ├── services/
│   └── theme/
├── lua/
├── scripts/
├── assets/
├── tests/
├── docs/
└── README.md
```

You may change this structure if there is a technically superior reason, but preserve the separation between UI, services, configuration, installers, and tests.

---

## Bootstrap phase

First create only the minimum viable shell:

1. Quickshell starts.
2. A compact top bar appears.
3. Hyprland workspaces are displayed.
4. Clock works.
5. Basic system state works.
6. Quickshell exits cleanly.
7. No Caelestia files are touched.
8. No unnecessary packages are installed.

Then validate the architecture before adding visual features.

Do not generate the entire desktop in one giant file.

---

## Agent behavior

You are an engineering agent, not a code autocomplete machine.

Before changing architecture:

- inspect existing project files
- verify package availability
- verify Quickshell APIs against the installed version
- verify Hyprland IPC/API behavior
- avoid deprecated APIs
- prefer documented/current interfaces
- test incrementally

If a package/API is uncertain, investigate it instead of hallucinating an implementation.

At the end of this phase, provide:

- dependency manifest
- architecture diagram in Markdown
- install procedure
- rollback procedure
- test procedure
- known limitations

Do not proceed to feature-heavy UI until the bootstrap passes.
