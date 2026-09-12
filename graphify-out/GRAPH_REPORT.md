# Graph Report - rice-j  (2026-09-12)

## Corpus Check
- Corpus is ~11,354 words - fits in a single context window. You may not need a graph.

## Summary
- 137 nodes · 205 edges · 24 communities (7 shown, 17 thin omitted)
- Extraction: 71% EXTRACTED · 29% INFERRED · 0% AMBIGUOUS · INFERRED: 59 edges (avg confidence: 0.87)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- Installer Tooling
- Reliability & Test Infrastructure
- UI Design System & Motion
- Isolation & Hardware Constraints
- Shell Architecture & Services
- Doctor Health Checks
- Hyprland Config Generation
- Test Runner
- Dry-Run Wrapper
- Benchmark Script
- Hash-Guard Test
- Marker Strip Test
- Rollback Test
- Install Round-Trip Test
- Host Integration Smoke Test
- Gen-Conf Golden Test
- Lua Syntax Test
- Manifest Sync Test
- QML Lint Test
- Shellcheck Test
- Calendar Module
- Control Center
- Launcher
- Notifications

## God Nodes (most connected - your core abstractions)
1. `install.sh script` - 19 edges
2. `doctor.sh script` - 9 edges
3. `die()` - 9 edges
4. `mkdir_p()` - 9 edges
5. `uninstall.sh script` - 9 edges
6. `Quickshell shell toolkit` - 9 edges
7. `Jeri Desktop` - 8 edges
8. `log()` - 7 edges
9. `backup_file()` - 7 edges
10. `install_tree()` - 6 edges

## Surprising Connections (you probably didn't know these)
- `Design tokens (theme/ singletons)` --semantically_similar_to--> `Jeri Design Tokens`  [INFERRED] [semantically similar]
  docs/ARCHITECTURE.md → 02_UI_DASHBOARD_MEDIA.md
- `dependency-manifest.yaml (official repos)` --semantically_similar_to--> `Machine-readable dependency manifest (spec)`  [INFERRED] [semantically similar]
  dependency-manifest.yaml → 03_RELIABILITY_INSTALL_TESTING.md
- `Caelestia coexistence guarantee` --semantically_similar_to--> `Non-negotiable isolation requirement`  [INFERRED] [semantically similar]
  03_RELIABILITY_INSTALL_TESTING.md → 01_ARCHITECTURE_ISOLATION.md
- `Jeri Design Tokens` --conceptually_related_to--> `Jeri Desktop`  [INFERRED]
  02_UI_DASHBOARD_MEDIA.md → 01_ARCHITECTURE_ISOLATION.md
- `Jeri Desktop README` --conceptually_related_to--> `Jeri Desktop`  [INFERRED]
  README.md → 01_ARCHITECTURE_ISOLATION.md

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Jeri design language core** — 02_ui_dashboard_media_design_tokens, 02_ui_dashboard_media_rest_react, 02_ui_dashboard_media_morphing_dashboard, 02_ui_dashboard_media_motion_system, 02_ui_dashboard_media_top_bar, 02_ui_dashboard_media_reduced_motion [INFERRED 0.85]
- **Morphing dashboard modules** — 02_ui_dashboard_media_morphing_dashboard, 02_ui_dashboard_media_calendar, 02_ui_dashboard_media_media_player, 02_ui_dashboard_media_performance_page, 02_ui_dashboard_media_control_center [INFERRED 0.75]
- **Reproducible install & validation flow** — 03_reliability_install_testing_installer, 03_reliability_install_testing_dependency_manifest, 03_reliability_install_testing_docker_env, 03_reliability_install_testing_test_strategy, 03_reliability_install_testing_recovery, compose_validate [INFERRED 0.85]

## Communities (24 total, 17 thin omitted)

### Community 0 - "Installer Tooling"
Cohesion: 0.16
Nodes (27): install.sh script, assert_isolated_dir(), backup_file(), check_disk_space(), check_hash(), die(), err(), hyprland_integrate() (+19 more)

### Community 1 - "Reliability & Test Infrastructure"
Cohesion: 0.14
Nodes (19): Docker isolated build environment, Media player (signature component), MPRIS media interface, Now Playing capsule, Machine-readable dependency manifest (spec), Docker development environment, Transactional installer (install/uninstall/doctor/dry-run), Official-repo-only pacman rule (+11 more)

### Community 2 - "UI Design System & Motion"
Cohesion: 0.14
Nodes (17): Bootstrap phase (minimal viable shell), Ambient focus field (wow feature), Jeri Design Tokens, Glass / depth surface stack, Light follows focus, Morphing dashboard (grows from top bar), Motion design system (presets + easing), Visual performance mode (Full/Balanced/Lite) (+9 more)

### Community 3 - "Isolation & Hardware Constraints"
Cohesion: 0.17
Nodes (15): Caelestia (quality benchmark), Fresh Arch Linux install requirement, Non-negotiable isolation requirement, Jeri Desktop, Performance requirement (old Intel GPU), jeri-desktop XDG namespace, Performance page (radial indicators), Caelestia coexistence guarantee (+7 more)

### Community 4 - "Shell Architecture & Services"
Cohesion: 0.27
Nodes (11): Hyprland compositor, Quickshell shell toolkit, Technology rules (Hyprland/QML/Lua split), Quickshell UI is QML (no Lua UI), Shell implementation architecture (components/modules/services/theme), Stable API preference over experimental APIs, Event-driven zero-polling design, Four-layer architecture (packages/Hyprland/Quickshell/scripts) (+3 more)

### Community 5 - "Doctor Health Checks"
Cohesion: 0.36
Nodes (7): fail(), pass(), doctor.sh script, warn_check(), detect_caelestia(), require_arch_linux(), require_host_arch()

### Community 6 - "Hyprland Config Generation"
Cohesion: 0.83
Nodes (3): emit(), render(), run()

## Knowledge Gaps
- **28 isolated node(s):** `dry-run.sh script`, `lib.sh script`, `bench.sh script`, `test_hash_guard.sh script`, `test_marker_strip.sh script` (+23 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **17 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Jeri Desktop` connect `Isolation & Hardware Constraints` to `Reliability & Test Infrastructure`, `UI Design System & Motion`, `Shell Architecture & Services`?**
  _High betweenness centrality (0.083) - this node is a cross-community bridge._
- **Why does `Quickshell shell toolkit` connect `Shell Architecture & Services` to `Reliability & Test Infrastructure`, `UI Design System & Motion`, `Isolation & Hardware Constraints`?**
  _High betweenness centrality (0.081) - this node is a cross-community bridge._
- **Why does `dependency-manifest.yaml (official repos)` connect `Reliability & Test Infrastructure` to `Shell Architecture & Services`?**
  _High betweenness centrality (0.060) - this node is a cross-community bridge._
- **What connects `dry-run.sh script`, `lib.sh script`, `bench.sh script` to the rest of the system?**
  _28 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Reliability & Test Infrastructure` be split into smaller, more focused modules?**
  _Cohesion score 0.14035087719298245 - nodes in this community are weakly interconnected._
- **Should `UI Design System & Motion` be split into smaller, more focused modules?**
  _Cohesion score 0.13970588235294118 - nodes in this community are weakly interconnected._