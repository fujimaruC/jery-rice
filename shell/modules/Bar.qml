import Quickshell
import QtQuick
import QtQuick.Layouts
import "../theme"
import "../services"
import "../components"
import "../modules"



PanelWindow {
    id: root


    property var modelData

    signal openDashboard()
    signal openControl()
    signal openLauncher()
    signal capsuleClicked()

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: Metrics.barHeight
    color: "transparent"
    exclusiveZone: Metrics.barHeight
    focusable: false

    Rectangle {
        anchors.fill: parent
        // Was Colors.base — identical to the app canvas, so the bar had no
        // contrast of its own and depended entirely on a 1px top hairline to
        // read as a distinct layer. surface (L1) gives it a real, if subtle,
        // presence as the shell's persistent chrome.
        color: Colors.surface
        opacity: Effects.surfaceOpacity

        Rectangle {
            anchors.top: parent.top
            width: parent.width
            height: Metrics.borderWidth
            color: Colors.border
        }

        // Bottom hairline separates the bar from whatever's beneath it,
        // matching the edge treatment every other surface in the system
        // already gets from its own border — the bar previously had this on
        // only one side.
        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: Metrics.borderWidth
            color: Colors.border
            opacity: Effects.hairlineOpacity
        }

        RowLayout {
            anchors {
                left: parent.left
                right: parent.right
                verticalCenter: parent.verticalCenter
                leftMargin: Metrics.padMd
                rightMargin: Metrics.padMd
            }
            spacing: Metrics.gapSm


            Text {
                text: "JERI"
                font.family: Typography.familyMono
                font.pixelSize: Typography.sizeSm
                font.weight: Typography.weightBold
                font.letterSpacing: Typography.letterSpacingWide
                color: Colors.accent
                Layout.alignment: Qt.AlignVCenter

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.openDashboard()
                }
            }


            Row {
                id: wsRow
                Layout.alignment: Qt.AlignVCenter
                spacing: Metrics.gapXs
                Layout.leftMargin: Metrics.gapMd

                Repeater {
                    model: HyprlandService.sortedWorkspaces()

                    JeriWorkspaceIndicator {
                        workspaceId: modelData.id
                        active: HyprlandService.focusedWorkspace === modelData

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: HyprlandService.switchWorkspace(modelData.id)
                        }
                    }
                }
            }

            Item { Layout.fillWidth: true }


            NowPlayingCapsule {
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredHeight: Metrics.controlHeight
                dashOpen: dashboardOpen
                onCapsuleClicked: root.capsuleClicked()
            }

            property bool dashboardOpen: false


            Row {
                Layout.alignment: Qt.AlignVCenter
                spacing: Metrics.gapSm

                JeriIcon {
                    glyph: AudioService.muted ? "volume_off" : "volume_up"
                    size: Metrics.iconSm
                    color: AudioService.muted ? Colors.fgFaint : Colors.fgMuted
                }
                JeriIcon {
                    glyph: NetworkService.wifi ? "wifi"
                        : (NetworkService.wired ? "network_check" : "power")
                    size: Metrics.iconSm
                    color: NetworkService.active ? Colors.fgMuted : Colors.fgFaint
                }
                JeriIcon {
                    glyph: BatteryService.present
                        ? (BatteryService.charging ? "battery_charging"
                          : BatteryService.percentage > 60 ? "battery_full"
                          : BatteryService.percentage > 25 ? "battery4"
                          : "battery_alert")
                        : "power"
                    size: Metrics.iconSm
                    color: BatteryService.present ? Colors.fgMuted : Colors.fgFaint
                }
            }


            JeriIcon {
                glyph: "settings"
                size: Metrics.iconSm
                color: Colors.fgMuted
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: Metrics.controlHeight
                Layout.preferredHeight: Metrics.controlHeight

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.openControl()
                }
            }


            Text {
                text: (clock.hours < 10 ? "0" + clock.hours : clock.hours) + ":"
                    + (clock.minutes < 10 ? "0" + clock.minutes : clock.minutes)
                font.family: Typography.familyMono
                font.pixelSize: Typography.sizeMd
                font.weight: Typography.weightMedium
                color: Colors.fg
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: implicitWidth
                horizontalAlignment: Text.AlignRight

                SystemClock {
                    id: clock
                    precision: SystemClock.Minutes
                }
            }
        }
    }
}