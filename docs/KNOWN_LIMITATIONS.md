# Jeri Desktop — Known Limitations (Bootstrap, Part 1)

Deliberate scope decisions for the bootstrap phase. Each has a `ponytail:` upgrade marker in code or an explicit next step.

## UI / features (not yet built — Part 2/3)

- No dashboard, calendar, media player, performance page, control center, launcher, notifications, overview yet. Bar shows workspaces + clock + memory only.
- Single top bar per monitor; no multi-tab dashboard morphing yet.
- Theme singletons are static defaults; the user `jeri.json` is not yet wired into the QML runtime (Part 2).
- No wallpaper accent palette sampling yet.

## Integration

- Keybinds: none auto-bound yet beyond the generated include placeholders; the `jeri.json` → hyprland keybind pipeline ships with the dashboard phase.
- Hyprland include is append-only via one marked line. If the user's `hyprland.conf` lacks the marker, the installer reports rather than modifies.
- No session/systemd unit (desktop entry provided; user starts the wrapper).

## Performance

- `SystemService` reads `/proc/meminfo` + `/proc/uptime` via a 10 s `Process`. Acceptable-low; the ceiling is a `FileView`/procfs reader that spawns nothing (marked `ponytail:` in code).
- `Motion`/`Effects` defaults are Balanced; blur/ambient effects still gated but not yet exercised by UI.

## Testing

- Docker does static + sandbox tests only (shellcheck, luac, qmllint, gen-conf golden, installer round-trip/rollback/hash-guard). It cannot prove a real Wayland session.
- Live Wayland validation (`tests/integration-host.sh`, `scripts/bench.sh`) requires a host Hyprland session and is not run from Docker.
- Media/MPRIS fixtures (`python-dbusmock`) land with the media-player phase.