pragma Singleton
import QtQuick

Item {



    // Elevation ramp: each tier is a deliberate, visible step lighter than the
    // last. In a dark theme, "closer to the user" reads as "lighter" — so
    // assign tiers by actual stacking order, not by which file happens to
    // reference them:
    //   base          L0  app canvas (wallpaper shows through)
    //   surface       L1  always-on chrome anchored to the canvas (Bar)
    //   surfaceAlt    L2  content embedded inside a panel (Card, list rows)
    //   surfaceRaised L3  floating/popover surfaces (ControlCenter, Dashboard,
    //                     Launcher) — the most elevated thing on screen, so it
    //                     must read as the lightest surface, not the darkest.
    readonly property color base:          "#0d0e11"
    readonly property color surface:       "#15171c"
    readonly property color surfaceAlt:    "#1b1e25"
    readonly property color surfaceRaised: "#23272f"
    readonly property color glass:         "#12141a"
    readonly property color border:        "#262b34"

    // borderFocus: a *hover* cue (mouse only) — one step brighter than the
    // resting border, still subtle. Keyboard focus uses focusRing below,
    // which is intentionally much stronger; the two must never look the same.
    readonly property color borderFocus:   "#3d4a63"
    readonly property color focusRing:     "#7aa2f7"

    readonly property color fg:            "#e7e9ee"
    readonly property color fgMuted:       "#9aa1ad"
    readonly property color fgFaint:       "#6b727d"

    readonly property color accent:        "#7aa2f7"
    readonly property color accentMuted:   "#3a537f"
    readonly property color accentWarm:    "#e0a458"
    readonly property color accentSoft:    "#2e7aa2f7"
    readonly property color accentFaint:   "#1f7aa2f7"

    readonly property color hoverOverlay:  "#14ffffff"
    readonly property color pressOverlay:  "#26ffffff"
    // Neutral hover tint for embedded rows/items that aren't "active" —
    // previously many of these leaned on accentSoft or borderFocus for
    // hover, which quietly turned hover into a weaker version of the
    // active/selected signal. Keeping them visually distinct: hover is
    // always neutral, accent is reserved for real state.
    readonly property color hoverTint:     "#0dffffff"

    // Hairline divider for separating embedded rows without boxing them —
    // the replacement for reaching for `border` (a box edge) when what was
    // actually needed was a line between two things in a list.
    readonly property color line:          "#1c2029"

    readonly property color ok:            "#9ece6a"
    readonly property color warn:          "#e0a458"
    readonly property color danger:        "#f7768e"

    readonly property color scrim:         "#000000"
    readonly property real scrimOpacity:   0.35

    readonly property real surfaceOpacity: 0.92
}