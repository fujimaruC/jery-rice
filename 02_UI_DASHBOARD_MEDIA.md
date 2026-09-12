# Part 2/3 — Jeri Desktop UI/UX: Modern Motion, Minimalism & Signature Effects

## Creative direction

Build a desktop shell that makes an experienced Linux/Arch user stop and ask:

> "What the hell is that shell?"

The answer must NOT be "because it has lots of effects."

The identity should come from:

- extremely clean composition
- excellent motion design
- intelligent UI morphing
- small details that react to the user's actions
- premium-feeling depth
- restrained glow
- contextual surfaces
- extremely low visual noise
- lightweight implementation

The supplied screenshot is the broad visual inspiration: compact rounded cards, a sophisticated dashboard, strong hierarchy, elegant dark surfaces, and animated-feeling interaction.

Do NOT reproduce it pixel-for-pixel.

Do NOT copy Caelestia.

Treat the screenshot and Caelestia only as references for polish.

The desired design philosophy is:

> **Minimal at rest. Alive in motion. Invisible until needed.**

---

# 1. The "Jeri" design language

The entire interface must feel like one cohesive operating environment.

Avoid the common Linux-rice problem where:

- the bar comes from one project
- launcher comes from another
- notification UI looks unrelated
- system monitor has different typography
- control panel has different corner radii
- animations all use different timing

Everything must share one visual grammar.

Define a global design system:

```text
Jeri Design Tokens
├── Color
├── Surface
├── Border
├── Typography
├── Radius
├── Spacing
├── Elevation
├── Motion
└── Interaction
```

Centralize these values.

---

# 2. Visual personality

Target:

- premium
- futuristic
- calm
- precise
- technical
- understated
- slightly cinematic

Avoid:

- gamer RGB aesthetics
- cyberpunk clutter
- excessive neon
- giant floating widgets
- excessive gradients
- permanent glowing borders
- huge shadows
- 2010-era Conky styling
- rounded-everything-with-no-hierarchy
- UI that constantly moves for no reason

The desktop should look almost boring for the first two seconds.

Then the user interacts with it.

That is where the magic happens.

---

# 3. Core concept: "Rest / React"

The shell has two visual states.

## REST

When nothing is happening:

- compact bar
- small workspace indicators
- quiet clock
- tiny system status
- almost no animation
- low visual weight
- no giant dashboard

The desktop should feel spacious.

## REACT

When the user interacts:

- panels gently expand
- controls reveal themselves
- cards morph rather than abruptly appear
- elements slide from their logical origin
- focus follows the cursor/keyboard
- context-specific information appears
- subtle light/glow follows active elements

The shell should feel responsive without feeling busy.

---

# 4. Signature interaction: Morphing dashboard

Do NOT make the dashboard simply "fade in from nowhere."

The dashboard should appear to **grow from the top bar**.

Conceptually:

```text
NORMAL

┌──────────────────────────────────────────┐
│ JERI   1 2 3 4       21:42           │
└──────────────────────────────────────────┘


              ↓ open


╭────────────────────────────────────────────╮
│ Dashboard    Media    Performance          │
├────────────────────────────────────────────┤
│                                            │
│  Time / Calendar      System               │
│                                            │
│  Workspaces             Performance        │
│                                            │
│              Media player                  │
╰────────────────────────────────────────────╯
```

The transition should visually imply that the dashboard is part of the bar rather than a separate application.

Implementation:

- animate geometry
- animate opacity
- animate corner radii when practical
- animate surface elevation
- keep duration short
- use easing curves designed for UI motion

Do not use long cinematic transitions.

Target roughly:

- fast interactions: ~120–180 ms
- panel morph/open: ~180–280 ms
- larger content transition: ~200–320 ms

These are targets, not hard-coded commandments. Tune by measurement and feel.

---

# 5. Motion design system

Define reusable motion presets.

Example:

```text
Motion.Fast
Motion.Normal
Motion.Slow
Motion.Snappy
Motion.Gentle
Motion.Exit
```

Also define easing presets.

Do NOT manually invent a new animation curve for every component.

Use a consistent motion language.

---

# 6. Micro-interactions

Small interactions should provide the "wow" effect.

Examples:

### Workspace indicator

When switching workspace:

- active pill expands slightly
- inactive indicators compress
- a small highlight travels to the new workspace
- surrounding layout adjusts smoothly

Do NOT bounce the indicator.

---

### Button hover

A control can:

- subtly brighten
- raise surface contrast
- show a tiny accent bloom
- move 1–2 px at most when appropriate

Avoid huge hover transforms.

---

### Toggle

A switch should:

- move smoothly
- slightly brighten its active track
- produce a tiny local glow
- settle quickly

The glow must be localized, not a giant aura.

---

### Progress / volume

Use smooth interpolation.

When changing volume or brightness:

- value changes continuously
- label can temporarily appear
- indicator can expand during interaction
- retract after a short timeout

---

# 7. "Light follows focus"

One signature effect:

When the user moves focus between dashboard cards or controls, a subtle ambient highlight should move toward the active element.

Conceptually:

```text
┌───────────────┬───────────────┐
│               │       *       │
│   Calendar    │   Media       │
│               │               │
└───────────────┴───────────────┘
```

The `*` represents a very soft localized highlight, not a literal star.

Implementation options in descending order of preference:

1. normal QML gradients/opacity layers
2. simple blurred/translucent layer
3. ShaderEffect only when proven inexpensive

Do NOT keep a continuously moving shader running while idle.

---

# 8. Glass / depth effect

Use depth without turning the shell into a glassmorphism museum.

Recommended surface stack:

```text
Wallpaper
   ↓
very subtle translucent base
   ↓
main surface
   ↓
hairline border
   ↓
small elevation shadow
   ↓
focused accent
```

The visual goal is:

- translucent
- soft
- deep
- readable

Not:

- transparent text over wallpaper
- unreadable cards
- huge blur radius
- constant expensive compositing

Prefer the cheapest visual implementation that creates the desired perception.

---

# 9. Ambient wallpaper relationship

Optional advanced effect:

The shell may derive a small accent palette from the current wallpaper.

For example:

```text
wallpaper
   ↓
sample / derive palette
   ↓
accent
   ↓
dashboard highlights
   ↓
media controls
   ↓
active workspace
```

The UI must NOT continuously analyze the wallpaper.

Perform this only when the wallpaper changes.

Provide a manual fixed-accent fallback.

---

# 10. Top bar

The top bar must be extremely compact.

Suggested composition:

```text
┌────────────────────────────────────────────────────┐
│     1  2  3  4  ·                    21:42    │
└────────────────────────────────────────────────────┘
```

Possible elements:

- small launcher mark
- workspaces
- active application/workspace state
- clock
- network
- audio
- battery

Avoid putting every metric in the bar.

The bar is a status surface.

The dashboard is where information lives.

---

# 11. Dynamic bar behavior

The bar should subtly adapt.

Examples:

### Idle

Minimal.

### Media playing

A small media capsule can appear.

```text
┌──────────────────────────────┐
│  ♪ Laufey · From The Start   │
└──────────────────────────────┘
```

It should not permanently consume huge width.

### Notification

A tiny notification indicator can briefly appear and settle.

### Workspace transition

The active workspace indicator should provide visual confirmation.

---

# 12. Dashboard composition

The dashboard should feel like a **control room**, but miniature.

Do not fill every empty pixel.

Suggested hierarchy:

```text
╭────────────────────────────────────────────────╮
│ Dashboard        Media        System           │
├────────────────────────────────────────────────┤
│                                                │
│   09:42 PM             CALENDAR                │
│   Thursday             September 2026          │
│                                                │
│   WORKSPACES            SYSTEM                 │
│   1  2  3  4           CPU  RAM  TEMP         │
│                                                │
│   MEDIA PLAYER                                │
│   ┌────────────────────────────────────────┐   │
│   │ artwork   title / artist       controls │   │
│   └────────────────────────────────────────┘   │
╰────────────────────────────────────────────────╯
```

Exact geometry is free to evolve.

The final interface must be substantially more compact than the supplied screenshot.

---

# 13. Dashboard tabs

Use a small top navigation row.

Recommended:

```text
Dashboard   Media   Performance
```

Optional:

```text
Control
```

Do not create tabs merely because tabs look modern.

Every tab must expose a genuinely different information domain.

Transitions between tabs should feel like one surface changing state.

Avoid destroying/recreating the entire dashboard for every tab switch.

Prefer keeping lightweight root structure and swapping content.

---

# 14. Dashboard transition

When changing tabs:

- previous content slides/fades a tiny amount
- new content enters from the direction of navigation
- header indicator follows the selected tab
- cards should maintain visual continuity

Do NOT use:

- cube rotations
- page flips
- giant zooms
- elastic bouncing

The effect should feel like a modern operating system, not a presentation slideshow.

---

# 15. Calendar

Create a compact, elegant calendar.

Visual hierarchy:

```text
September 2026
    <            >

Su Mo Tu We Th Fr Sa
       1  2  3  4  5
 6  7  8  9 [10] 11 12
13 14 15 16 17 18 19
20 21 22 23 24 25 26
27 28 29 30
```

Current date should be visually obvious without becoming enormous.

Interactions:

- previous month
- next month
- keyboard navigation where practical
- optional click date

Keep it offline.

No online calendar service.

No account.

---

# 16. Media player: signature component

The media player is a primary feature.

Make it one of the most visually impressive components.

When playing:

```text
╭──────────────────────────────────────────╮
│                                          │
│      ╭──────────────╮                    │
│      │              │   From The Start   │
│      │   artwork    │   Laufey           │
│      │              │                    │
│      ╰──────────────╯   ──────────────   │
│                         01:23 / 03:32    │
│                    ◀     ▶     ▶         │
╰──────────────────────────────────────────╯
```

Do not copy this exact layout.

---

# 17. Media artwork motion

Optional high-impact effect:

Use a very subtle enlarged, heavily faded version of album artwork as a background layer behind the media card.

Rules:

- heavily darkened
- highly transparent
- static while idle
- no constant zoom
- no continuous rotation
- no expensive real-time blur

When track changes:

- artwork crossfades
- metadata crossfades or slides
- progress indicator transitions smoothly

This should feel cinematic for a fraction of a second, then become quiet again.

---

# 18. Media control behavior

Use MPRIS or another standard Linux media interface.

Support where available:

- play
- pause
- previous
- next
- seek
- title
- artist
- album
- playback state
- artwork

When no player exists:

```text
No media
```

Avoid polling aggressively.

Listen for media changes where the interface supports events.

Do not build a custom player backend unless absolutely necessary.

---

# 19. "Now Playing" capsule

When music starts while the dashboard is closed:

A tiny capsule may emerge from the top bar.

Example:

```text
          ╭──────────────────────────────╮
          │ ♪  Laufey  ·  From The Start │
          ╰──────────────────────────────╯
```

After a timeout:

```text
                    ↓

back to compact bar
```

It should feel like the desktop acknowledged the event, not like an advertisement for the song.

---

# 20. Performance page

Make system information visually interesting without making it noisy.

Instead of a wall of numbers, use a few elegant radial/arc indicators.

Example concept:

```text
       CPU                 RAM
      ╭────╮             ╭────╮
     ╱  34% ╲           ╱ 47% ╲
     ╲      ╱           ╲      ╱
      ╰────╯             ╰────╯

        51°C          ↓ 2.1 MB/s
```

Use simple QML shapes where possible.

Avoid excessive custom shaders.

Animate values smoothly only when values actually change.

When closed, monitoring should reduce to the minimum needed by the rest of the shell.

---

# 21. System "pulse" effect

Optional signature feature:

When a system value changes significantly, the related card can perform a microscopic pulse.

Examples:

- CPU spikes
- battery changes
- download begins
- microphone toggled

Pulse = tiny scale/opacity/accent change.

Not:

- flashing
- shaking
- bouncing

The shell should feel alive, not nervous.

---

# 22. Control center

The control center should feel like a compact instrument panel.

Potential controls:

```text
Wi-Fi       Bluetooth
Audio       Microphone
Brightness  Night Light
DND         Battery
```

Use a mixture of:

- compact toggles
- icon + state
- small sliders
- local value readouts

Controls should morph visually between states.

Do not use enormous iOS-style tiles.

The design should remain recognizably Linux/desktop-oriented.

---

# 23. Launcher

The launcher should be extremely fast.

When opened:

- background darkens very slightly
- a single compact search surface appears
- focus lands immediately in search
- results animate in with tiny stagger where practical

Example:

```text
╭────────────────────────────────────────╮
│ > firefox                              │
├────────────────────────────────────────┤
│  Firefox                               │
│  Chromium                              │
│  LibreWolf                             │
╰────────────────────────────────────────╯
```

Keep it compact.

Do not create a giant fullscreen launcher unless there is a strong usability reason.

---

# 24. Focus / keyboard navigation

Every major panel must work without a mouse.

Provide:

- obvious focus state
- keyboard navigation
- Enter/Space activation where appropriate
- Esc to close
- sensible directional navigation

Focus state should use a subtle surface/accent change.

Never rely solely on a glowing border to indicate focus.

---

# 25. Notifications

Notification toasts should be tiny and elegant.

Concept:

```text
╭────────────────────────────╮
│ Firefox                    │
│ Download complete          │
╰────────────────────────────╯
```

When a notification appears:

- enter quickly
- remain readable
- leave quietly

Do not create huge animated banners.

Notification center history can expand from the same visual family.

---

# 26. Desktop-wide contextual effects

Optional advanced interactions:

### Screenshot

After screenshot:

- a tiny preview capsule appears
- actions: open / copy / save
- disappears automatically

### Volume

After volume change:

- compact floating indicator
- animated level
- disappears after short timeout

### Brightness

Same concept.

### Workspace transition

A small contextual workspace label can appear briefly when moving across workspaces.

These are optional.

Do not implement all of them if they increase complexity too much.

---

# 27. The "wow" feature: ambient focus field

Create an optional subtle background focus field.

When dashboard is open:

- a very soft accent region follows the active card
- it moves slowly but only in response to interaction
- it stops when there is no focus change
- it fades away when dashboard closes

This is the sort of feature that should make someone say:

> "Why does this feel so polished?"

It is much more valuable than adding 20 extra widgets.

---

# 28. Blur strategy

Blur is expensive.

Use it strategically.

Preferred order:

1. opaque/translucent surface
2. compositor blur where already available
3. limited blur region
4. shader-based blur only if measured and justified

Never use maximum blur everywhere.

Do not blur the entire screen continuously.

Provide a performance mode that reduces visual effects.

---

# 29. Performance mode

Provide:

```text
Visual Mode
├── Full
├── Balanced
└── Lite
```

### Full

- richer transitions
- subtle ambient effects
- album-art atmosphere
- more visual depth

### Balanced

- most animations
- reduced ambient effects
- lower blur

### Lite

- minimal animation
- no expensive ambient effects
- no unnecessary background processing
- maximum compatibility with older hardware

The default for older hardware should be **Balanced**.

---

# 30. Reduced motion

Support an explicit reduced-motion preference.

When enabled:

- shorten transitions
- remove large movement
- remove ambient motion
- retain clear state changes

The UI must remain understandable without animation.

---

# 31. Responsiveness

The desktop must work well at:

- 1366×768
- 1600×900
- 1920×1080

Design should scale rather than simply stretch.

Use responsive QML layout primitives.

Do not hard-code a single giant dashboard width.

---

# 32. Error states are part of the design

If hardware/service information is unavailable, design the fallback beautifully.

Examples:

```text
GPU
Unavailable
```

instead of:

```text
undefined
NaN
null
```

For missing media:

```text
No media
```

For missing battery:

```text
Desktop power
```

The UI should never look broken just because a machine lacks a feature.

---

# 33. Accessibility

Support:

- keyboard navigation
- visible focus
- reasonable contrast
- adjustable font size where feasible
- reduced motion
- non-color-only status indication

Do not trade usability for visual novelty.

---

# 34. Implementation architecture

Keep UI modular.

Suggested:

```text
shell/
├── shell.qml
│
├── components/
│   ├── JeriPanel.qml
│   ├── JeriCard.qml
│   ├── JeriButton.qml
│   ├── JeriSlider.qml
│   ├── JeriToggle.qml
│   ├── JeriTab.qml
│   ├── JeriIcon.qml
│   └── JeriTransition.qml
│
├── modules/
│   ├── Bar.qml
│   ├── Dashboard.qml
│   ├── Calendar.qml
│   ├── MediaPlayer.qml
│   ├── Performance.qml
│   ├── ControlCenter.qml
│   ├── Launcher.qml
│   └── Notifications.qml
│
├── services/
│   ├── HyprlandService.qml
│   ├── MediaService.qml
│   ├── SystemService.qml
│   ├── NetworkService.qml
│   ├── AudioService.qml
│   ├── BatteryService.qml
│   └── NotificationService.qml
│
└── theme/
    ├── Colors.qml
    ├── Typography.qml
    ├── Metrics.qml
    ├── Motion.qml
    └── Effects.qml
```

Build reusable primitives before building complex screens.

---

# 35. Important Quickshell rule

Quickshell's UI is QML.

Do NOT attempt to create the UI as Lua.

Use:

- QML for Quickshell UI
- Hyprland configuration for compositor behavior
- Lua only for justified auxiliary configuration, data generation, or helper tooling

Do not introduce Lua merely to satisfy a file-extension requirement.

---

# 36. Animation implementation rules

Every animation must answer:

> What information does this movement communicate?

Valid examples:

- a panel grows from its trigger
- a selected tab indicator moves to the selected tab
- a value smoothly transitions
- a notification enters/exits
- media artwork changes between tracks

Invalid examples:

- permanent bouncing
- random floating
- continuous spinning
- looping glow
- excessive parallax
- animation simply to show that QML can animate

---

# 37. Performance constraints for animations

Animations must be cheap.

Prefer:

- opacity
- translation
- scale
- simple geometry changes

Be cautious with:

- large blur changes
- full-screen shader effects
- multiple simultaneous expensive effects
- continuously animated gradients
- image-heavy composition

When an effect has no measurable benefit, remove it.

The shell must still feel premium without relying on GPU-heavy tricks.

---

# 38. No fake modernity

Do not confuse:

```text
dark + blur + rounded corners
```

with modern design.

Modernity should come from:

- hierarchy
- spacing
- motion
- state transitions
- consistency
- restraint
- responsive interaction
- purposeful detail

The UI should remain beautiful even with effects disabled.

---

# 39. Visual QA checklist

Before declaring the UI finished, inspect it at:

- idle
- dashboard open
- tab switch
- workspace switch
- media start
- media stop
- media change
- notification arrival
- low battery
- missing battery
- unavailable network
- missing GPU information
- 1366×768
- 1920×1080
- reduced-motion mode
- Lite visual mode

Look specifically for:

- accidental clipping
- excessive empty space
- inconsistent radii
- inconsistent spacing
- ugly fallbacks
- text overlap
- animation lag
- visual noise

---

# 40. Definition of "mind-blowing"

Do NOT interpret "mind-blowing" as "add more effects."

The target feeling is:

> "This is ridiculously polished for something running on a lightweight Arch setup."

A user should be able to turn off the effects and still love the layout.

The effects should then make the interface feel unexpectedly alive.

The strongest final design should have this rhythm:

```text
REST
 ↓
gesture
 ↓
micro-response
 ↓
morph
 ↓
information
 ↓
quiet
```

Never:

```text
REST
 ↓
animation
 ↓
animation
 ↓
glow
 ↓
blur
 ↓
animation
 ↓
more animation
```

---

# 41. Creative freedom clause

You are explicitly encouraged to invent additional UI interactions that fit this design language.

Do NOT ask for permission before proposing or prototyping small visual ideas.

Experiment with:

- shape morphing
- contextual capsules
- subtle accent fields
- radial indicators
- layered surfaces
- intelligent empty states
- miniature overview transitions
- media-reactive metadata
- contextual controls
- spatial hierarchy
- tiny tactile feedback

But every experiment must satisfy:

1. useful or meaningfully delightful
2. lightweight enough for older hardware
3. visually coherent
4. removable or degradable in Lite mode
5. technically supportable by current Quickshell/QML APIs

When uncertain, prefer the simpler implementation.

---

# 42. Final visual target

Imagine the following progression:

### Desktop at rest

Almost nothing.

```text
      1  2  [3]  4                         21:42
```

### User opens dashboard

The bar gently unfolds into a compact control surface.

### User hovers a card

A tiny ambient highlight moves beneath it.

### User switches to Media

The dashboard content morphs rather than abruptly changes.

### Music starts

A compact "Now Playing" capsule briefly appears.

### Track changes

Artwork crossfades and metadata updates smoothly.

### User closes dashboard

Everything collapses back into the quiet desktop.

That is the identity.

**Minimal when untouched. Exceptional when interacted with.**

---

# 43. Completion criteria

The UI is complete only when:

- it looks intentionally modern without copying Caelestia
- it is significantly more compact than the supplied reference
- media player is a first-class component
- weather is NOT included
- profile/photo widgets are NOT included
- motion feels fast and deliberate
- interactions have coherent micro-animations
- dashboard morphing feels natural
- all components share one design system
- Full/Balanced/Lite visual modes exist
- reduced-motion mode exists
- old Intel hardware remains usable
- visual effects degrade gracefully
- unavailable hardware does not produce ugly UI
- the shell remains beautiful when advanced effects are disabled
- no animation runs continuously without purpose
- no expensive visual effect is shipped without performance validation
Spatial Overview: Niri-inspired, Hyprland-native, Quickshell implementation. No HyprPM plugin.
The final result should look like a desktop someone intentionally designed, not a collection of Linux widgets glued together.
