# Jeri Visual System

Written before implementation, as the reference every subsequent change is
checked against. Supersedes ad-hoc visual decisions in the original
component set.

## 1. Visual philosophy

Jeri is instrumentation, not decoration. The shell should feel like a
cockpit readout that's almost always quiet — most of the screen is the
user's wallpaper — and becomes sharp and immediate the moment it's touched.
No layer should exist just because "a desktop shell has one of these."
Every surface earns its presence through a hierarchy signal (see §2) or it
doesn't get a surface at all — it gets typography and spacing instead.

The single biggest failure mode being corrected: **everything was a
bordered, rounded rectangle at similar opacity**, so the eye had no cue for
what mattered. A toggle, a slider, a label, and a floating popover all used
the same "card" treatment. Hierarchy has to come from *contrast of
treatment*, not from fifteen near-identical grays.

## 2. Surface hierarchy

Four tiers, each triggered by *role*, not by "whichever token was closest at
hand":

| Tier | Role | Treatment |
|---|---|---|
| Canvas | wallpaper | untouched |
| Chrome | Bar — always present, always quiet | flat fill, no border except the single edge touching the screen boundary; nothing inside it gets its own border |
| Embedded | content living inside a floating surface (rows, list items, gauges) | **no card, no border** by default — separated by spacing and hairline dividers, not boxes. A background tint only appears on hover/press/selected |
| Floating | Dashboard / ControlCenter / Launcher / MediaPlayer-expanded | the only tier allowed a border + shadow + the lightest fill — because it's the one thing genuinely floating above the canvas |

Rule that falls out of this: **a component doesn't get a border merely for
existing.** A border on an embedded element now specifically means "this is
a floating surface" — so overloading it everywhere destroyed the signal.
`JeriCard`'s default border is removed; floating containers keep theirs.

## 3. Spacing rhythm

Base unit 4px (unchanged), but the actual *usage* rule changes: spacing
between unrelated groups is always ≥ `gapLg`, spacing between related
items in one group is `gapSm`/`gapXs`, and nothing in between. The original
system had the right tokens but used `gapSm` for both "two icons in the
same control" and "two unrelated sections," flattening the grouping signal
spacing exists to provide.

## 4. Typography hierarchy

Six roles, mapped onto the existing size tokens instead of adding new
files that would fragment further:

| Role | Token | Weight | Use |
|---|---|---|---|
| Display | `size2xl` | Semibold | rare — a single hero number (e.g. clock in an expanded view) |
| Heading | `sizeXl` | Semibold | section titles inside floating surfaces |
| Body | `sizeSm` | Medium/Normal | primary labels, media title |
| Metadata | `sizeXs` | Normal, `fgMuted`/`fgFaint` | secondary descriptive text |
| System data | `sizeSm`/`sizeMd`, **mono** | Medium | clock, CPU%, network throughput — anything measuring something |
| Controls | `sizeSm`, Medium | button/toggle/tab labels |

Monospace is reserved for *measurements* (clock, gauges, byte counts) — not
applied to labels or descriptions, which was inconsistent before (bar clock
was mono, but percentages elsewhere weren't consistently).

## 5. Color hierarchy

- `accent` is reserved for **state**: active workspace, playing media,
  selected tab, a control that's "on." It is not a default border-hover
  color for things that aren't actually active — that duty moves to a new
  neutral `hoverTint`.
- Neutral text/surface ramp stays as fixed in the previous pass
  (base < surface < surfaceAlt < surfaceRaised, each a real visible step).
- A new `line` token (`Colors.line`) replaces `border` for the common case
  of a hairline divider between embedded rows — visually softer than a
  full 1px border-on-a-box, and it's what most "separation" in this UI
  actually needs instead of a box.

## 6. Interaction language

Resting → Hover → Focus → Pressed → Selected/Active → Disabled, and no two
of these render identically:

- **Hover**: background tint (`hoverTint`) fades in. No border change.
- **Focus** (keyboard only): a ring, `Colors.focusRing`, drawn outside the
  element. Never combined with the hover tint's logic — focus can be true
  without hover.
- **Pressed**: `Motion.pressScale` (0.97) scale-down. Physical, immediate.
- **Selected/Active**: accent color takes over an icon/text/indicator —
  no background box unless the tier calls for one (e.g. an active
  workspace pill, which is intentionally the one exception because it's
  the shell's primary "where am I" signal).
- **Disabled**: opacity 0.4, no hover/press behavior at all (not just
  visually suppressed — literally non-interactive).

## 7. Motion language

Kept the existing `Motion.fast/normal/slow/snappy/gentle` scale and the
Full/Balanced/Lite/reduced-motion gating — it was sound, just under-used
consistently. Rules going forward:

- **Appear**: fade + slight scale-from-0.98 (never slide-from-offscreen for
  popovers anchored to a fixed point — they should feel like they *are*
  there, resolving into focus, not arriving from a direction).
- **Directional content change** (tab switch, dashboard page): horizontal
  slide, using `JeriTransition`'s existing direction property — kept as
  the one deliberately spatial motion, because tabs are the one place
  "coming from somewhere / going somewhere" is actually true.
- **Press**: scale only, never position (a translate reads as misalignment
  at these sizes, not as a push).
- **State toggles** (on/off, selected/unselected): color/opacity
  crossfade at `Motion.fast` — never a spring/overshoot, which is reserved
  for the one place it communicates something physical: the toggle knob
  sliding into its new position.

## 8. Component rules

Audit outcome for each existing primitive:

| Component | Verdict | Why |
|---|---|---|
| `JeriButton` | Keep, refine | genuinely reusable; hover/focus/press already unified in the previous pass |
| `JeriCard` | Keep, re-scope | was the main source of "everything is a bordered box" — becomes borderless by default, border opt-in for floating use |
| `JeriIcon` | Keep as-is | correctly minimal already |
| `JeriPanel` | Merge into `JeriCard` conceptually | near-duplicate of `JeriCard` (same shadow/border/margin logic, different defaults) — kept as a thin floating-surface preset instead of a parallel implementation |
| `JeriSlider` | Keep, refine | tactile already (drag, value bubble); track/knob get the hairline-not-border treatment |
| `JeriTab` | Keep | already closer to "integrated" than "generic button"; underline mechanism is right |
| `JeriToggle` | Keep, refine | focus ring added in the previous pass; visual otherwise sound |
| `JeriTransition` | Keep | the one deliberately spatial motion primitive; used correctly |
| `JeriWorkspaceIndicator` | Keep, refine | correct concept (pill grows when active); inactive dots were touching `fgMuted` directly instead of a token meant for exactly this |
| `RadialGauge` | Keep | appropriately data-forward, mono type already |

No primitive is deleted outright — the actual problem was never "too many
components," it was that they didn't share a hover/focus/press/border
vocabulary. `JeriPanel` is folded down to a thin preset over `JeriCard`
rather than kept as a second, slightly-different implementation of the
same shadow+border+radius logic.
