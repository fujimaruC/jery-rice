# Part 3/3 — Reliability, Installation, Testing & Delivery Specification

## Goal

Turn Jeri Desktop into a reproducible, stable Arch Linux project that can be installed fresh without interfering with Caelestia.

This phase is about engineering quality.

Do not optimize for "lots of features."

Optimize for:

- stability
- recoverability
- predictable installation
- low resource usage
- clean architecture
- maintainability

---

# Package management

Before installing dependencies:

```bash
pacman -Si <package>
pacman -Ss <search>
```

Use these to verify availability.

Never assume package names.

Prefer official Arch repositories.

If an AUR package is unavoidable:

1. explain why
2. verify the package
3. pin/document the dependency expectation
4. provide a fallback if practical
5. never silently install random third-party scripts

Do not use curl-pipe-shell installation patterns for unknown software.

---

# Dependency manifest

Create a machine-readable dependency manifest.

Example:

```text
runtime:
  hyprland
  quickshell
  ...
optional:
  ...
build:
  ...
```

The exact packages must be determined by actual implementation.

Every package must be used.

If a package is removed from the implementation, remove it from the dependency manifest.

---

# Installation architecture

The installer must support:

```bash
./install.sh
./install.sh --dry-run
./install.sh --check
./uninstall.sh
./doctor.sh
```

The installer must:

1. verify Arch Linux
2. verify architecture
3. check disk space
4. detect existing Jeri Desktop installation
5. detect Caelestia without modifying it
6. verify dependencies
7. install missing dependencies
8. create isolated directories
9. copy configuration
10. validate configuration
11. create required desktop/session integration
12. report exactly what changed

Never overwrite unrelated files.

---

# Caelestia coexistence

The user may keep Caelestia installed.

Therefore:

- Jeri Desktop must have its own config directory
- Jeri Desktop must have its own Quickshell configuration
- Jeri Desktop must have its own scripts
- Jeri Desktop must have its own state/cache
- Jeri Desktop must not modify Caelestia
- Jeri Desktop must not depend on Caelestia
- uninstalling Jeri Desktop must not affect Caelestia

If Hyprland configuration must be changed, create a clearly isolated include or generated configuration owned by Jeri Desktop.

Do not rewrite the user's complete existing Hyprland config.

Provide a reversible integration method.

---

# Docker development environment

Create a Docker environment for:

- dependency validation
- shell syntax checks
- QML static checks where available
- Lua syntax checks
- installer tests
- file-layout tests
- configuration generation tests

The container must not require access to the user's private home directory.

Do not mount the entire host home directory.

Do not mount:

```text
~/.config
~/.ssh
~/.gnupg
```

For GUI testing, distinguish between:

1. static/build tests in Docker
2. real Wayland integration tests on a controlled host session

Do not claim Docker alone can fully validate a real Hyprland/Wayland graphical session.

---

# Test strategy

Create automated tests for:

## Installer

- clean installation
- already-installed state
- missing dependency
- unsupported distribution
- dry-run
- uninstall
- rollback

## Configuration

- malformed config detection
- missing files
- invalid paths
- permission problems

## Quickshell

- shell starts
- shell exits
- components load independently
- missing optional services do not crash the entire shell

## Hyprland

- workspace IPC works
- keybinds do not conflict with existing configuration
- generated configuration is syntactically valid

## Media

Test against at least one known MPRIS-compatible player.

Test:

- no player
- paused
- playing
- next
- previous
- missing artwork

## System metrics

Test:

- CPU
- RAM
- battery absent
- GPU metric unavailable
- temperature unavailable
- network unavailable

Every unavailable metric must degrade gracefully.

---

# Logging

Create controlled logs.

Do not spam the terminal.

Logs should include:

- startup
- service initialization
- errors
- warnings
- shutdown

Do not log:

- passwords
- tokens
- private messages
- unnecessary personal data

Provide a debug mode.

Normal mode should remain quiet.

---

# Recovery

If installation fails halfway:

- do not leave a broken partial installation
- report the failure
- restore files created by the installer where safe
- never touch Caelestia files
- preserve logs for diagnosis

Uninstaller should remove only files explicitly owned by Jeri Desktop.

Maintain a manifest of installed/created files.

---

# Performance acceptance targets

On older hardware, aim for:

- fast shell startup
- low idle CPU usage
- low idle memory usage
- no constant high-frequency process spawning
- no visible input lag
- no unnecessary animation while idle

Do not invent exact benchmark numbers without measuring them.

Measure before making performance claims.

Provide a benchmark script where practical.

---

# Stability rules

The agent must prefer stable APIs over experimental APIs.

Before adopting an API:

1. inspect the installed version
2. confirm that the API exists
3. check current documentation when available
4. implement
5. test

Do not blindly copy examples from outdated blog posts.

Do not assume an API from another Quickshell version works unchanged.

If a feature depends on an unstable API, mark it clearly and provide a safe fallback.

---

# Final repository requirements

The final repository must contain:

```text
README.md
LICENSE
Dockerfile
compose.yaml
install.sh
uninstall.sh
doctor.sh
dry-run.sh
dependency-manifest.*
config/
shell/
lua/
scripts/
tests/
docs/
```

Add a concise README covering:

- what Jeri Desktop is
- screenshots/placeholders
- architecture
- dependencies
- installation
- removal
- configuration
- troubleshooting
- coexistence with Caelestia
- known limitations

---

# Definition of done

Do not declare the project finished merely because the UI appears.

It is finished only when:

- fresh Arch installation is supported
- dependency detection works
- installation is reversible
- Caelestia remains untouched
- Docker build/test environment works
- Quickshell UI starts reliably
- Hyprland integration works
- dashboard works
- calendar works
- media player works
- performance panel works
- control center works
- workspace integration works
- launcher works
- notifications work
- unavailable hardware/features degrade gracefully
- logs are useful
- no critical dependency is hallucinated
- no known broken API is knowingly shipped
- configuration is modular
- documentation exists

---

# Agent execution order

Follow this exact order:

1. Inspect environment.
2. Create repository structure.
3. Create Docker development environment.
4. Verify package availability.
5. Build minimal Quickshell shell.
6. Validate Hyprland integration.
7. Implement theme system.
8. Implement bar/workspaces/clock.
9. Implement dashboard.
10. Implement calendar.
11. Implement media player.
12. Implement performance services.
13. Implement control center.
14. Implement launcher.
15. Implement notifications.
16. Add optional Lua tooling only where justified.
17. Build installer.
18. Build uninstaller.
19. Build doctor/dry-run tools.
20. Run static tests.
21. Run integration tests.
22. Measure performance.
23. Fix regressions.
24. Produce documentation.
25. Only then declare the project ready.

At every stage:

**Do not destroy existing user configuration.**
**Do not touch Caelestia.**
**Do not hallucinate packages or APIs.**
**Do not sacrifice stability for visual effects.**
