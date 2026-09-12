import QtQuick
import QtQuick.Layouts
import "../theme"
import "../services"
import "../components"
import "../components/JeriIcons.js" as JeriIcons





Item {
    id: root
    implicitWidth: 430
    implicitHeight: 120


    Image {
        id: atmosphere
        anchors.fill: parent
        source: MediaService.artUrl
        fillMode: Image.PreserveAspectCrop
        opacity: (MediaService.hasPlayer && Effects.artworkAtmosphere) ? 0.12 : 0
        visible: status === Image.Ready
        scale: 1.06
        Behavior on opacity { NumberAnimation { duration: Motion.gentle; easing.type: Motion.easeOut } }
    }

    RowLayout {
        anchors.fill: parent
        spacing: Metrics.gapLg


        Rectangle {
            id: artBox
            Layout.preferredWidth: Metrics.iconMd * 5
            Layout.preferredHeight: Metrics.iconMd * 5
            radius: Metrics.radiusMd
            color: Colors.surfaceRaised
            border.color: Colors.border
            border.width: Metrics.borderWidth
            layer.enabled: true

            Image {
                id: artOld
                anchors.fill: parent
                source: ""
                fillMode: Image.PreserveAspectCrop
                sourceSize: Qt.size(128, 128)
                opacity: 0
            }
            Image {
                id: artNew
                anchors.fill: parent
                source: ""
                fillMode: Image.PreserveAspectCrop
                sourceSize: Qt.size(128, 128)
                opacity: 1
            }


            Text {
                anchors.centerIn: parent
                text: JeriIcons.code("music_note")
                font.family: "Material Symbols Outlined"
                font.pixelSize: Metrics.iconMd * 2
                color: Colors.fgFaint
                visible: !MediaService.hasPlayer
            }
        }

        Column {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignVCenter
            spacing: Metrics.gapSm

            Text {
                id: titleLabel
                width: parent.width
                elide: Text.ElideRight
                text: MediaService.hasPlayer ? MediaService.title : "No media"
                font.family: Typography.family
                font.pixelSize: Typography.sizeLg
                font.weight: Typography.weightSemibold
                color: MediaService.hasPlayer ? Colors.fg : Colors.fgFaint
                Behavior on opacity { NumberAnimation { duration: Motion.fast; easing.type: Motion.easeOut } }
            }

            Text {
                id: subtitleLabel
                width: parent.width
                elide: Text.ElideRight
                text: MediaService.hasPlayer
                    ? (MediaService.artist + (MediaService.album ? "  ·  " + MediaService.album : ""))
                    : "Nothing playing"
                font.family: Typography.family
                font.pixelSize: Typography.sizeSm
                color: Colors.fgMuted
                Behavior on opacity { NumberAnimation { duration: Motion.fast; easing.type: Motion.easeOut } }
            }


            Rectangle {
                width: parent.width
                height: Metrics.touchTarget
                color: "transparent"

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                    height: Metrics.progressThickness
                    radius: Metrics.radiusFull
                    color: Colors.surfaceAlt

                    Rectangle {
                        height: parent.height
                        radius: Metrics.radiusFull
                        color: Colors.accent
                        width: parent.width * (MediaService.length > 0 ? MediaService.position / MediaService.length : 0)
                        Behavior on width {
                            NumberAnimation { duration: Motion.gentle; easing.type: Motion.easeSmooth }
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (MediaService.hasPlayer && MediaService.length > 0)
                            MediaService.setPosition((mouse.x / width) * MediaService.length)
                    }
                }
            }

            RowLayout {
                width: parent.width
                spacing: Metrics.gapXs

                Text {
                    text: MediaService.formatTime(MediaService.position)
                    font.family: Typography.familyMono
                    font.pixelSize: Typography.sizeXs
                    color: Colors.fgMuted
                }
                Text {
                    text: "/ " + MediaService.formatTime(MediaService.length)
                    font.family: Typography.familyMono
                    font.pixelSize: Typography.sizeXs
                    color: Colors.fgFaint
                }

                Item { Layout.fillWidth: true }

                JeriButton {
                    glyph: "skip_previous"
                    color: Colors.fgMuted
                    enabled: MediaService.hasPlayer
                    onClicked: MediaService.previous()
                }
                JeriButton {
                    glyph: MediaService.isPlaying ? "pause" : "play_arrow"
                    accent: true
                    enabled: MediaService.hasPlayer
                    onClicked: MediaService.togglePlay()
                }
                JeriButton {
                    glyph: "skip_next"
                    color: Colors.fgMuted
                    enabled: MediaService.hasPlayer
                    onClicked: MediaService.next()
                }
            }
        }
    }


    function onTrackChanged() {
        if (!MediaService.hasPlayer) { artNew.source = ""; artOld.source = ""; return }
        artOld.source = artNew.source
        artNew.source = MediaService.artUrl
        artOld.opacity = 1
        artNew.opacity = 0
        titleLabel.opacity = 0
        subtitleLabel.opacity = 0
        crossfade.restart()
    }
    Connections {
        target: MediaService
        function onTitleChanged() { root.onTrackChanged() }
        function onArtistChanged() { root.onTrackChanged() }
    }

    SequentialAnimation {
        id: crossfade
        running: false
        onRunningChanged: if (!running) { artOld.opacity = 0; titleLabel.opacity = 1; subtitleLabel.opacity = 1 }
        NumberAnimation { target: artNew; property: "opacity"; to: 1; duration: Motion.slow; easing.type: Motion.easeInOut }
        NumberAnimation { target: titleLabel; property: "opacity"; to: 1; duration: Motion.normal; easing.type: Motion.easeOut }
        NumberAnimation { target: subtitleLabel; property: "opacity"; to: 1; duration: Motion.normal; easing.type: Motion.easeOut }
        PauseAnimation { duration: 40 }
    }
}