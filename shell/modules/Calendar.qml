import QtQuick
import QtQuick.Layouts
import "../theme"
import "../components"



Item {
    id: root
    implicitWidth: 264
    implicitHeight: grid.height + header.height + Metrics.gapLg

    property date anchor: new Date(new Date().getFullYear(), new Date().getMonth(), 1)
    property var cells: []

    signal dayPicked(date day)

    function _rebuild() {
        var first = anchor.getDay()
        var dim = new Date(anchor.getFullYear(), anchor.getMonth() + 1, 0).getDate()
        var now = new Date()
        var out = []
        for (var i = 0; i < 42; i++) {
            var day = i - first + 1
            var inMonth = day >= 1 && day <= dim
            var dt = inMonth ? new Date(anchor.getFullYear(), anchor.getMonth(), day) : null
            var isToday = inMonth && dt.getFullYear() === now.getFullYear()
                && dt.getMonth() === now.getMonth() && dt.getDate() === now.getDate()
            out.push({ day: day, inMonth: inMonth, isToday: isToday, d: dt })
        }
        cells = out
    }

    function prevMonth() { anchor = new Date(anchor.getFullYear(), anchor.getMonth() - 1, 1); _rebuild() }
    function nextMonth() { anchor = new Date(anchor.getFullYear(), anchor.getMonth() + 1, 1); _rebuild() }
    function goToday()   { anchor = new Date(new Date().getFullYear(), new Date().getMonth(), 1); _rebuild() }

    Component.onCompleted: _rebuild()

    Column {
        id: col
        anchors.fill: parent
        spacing: Metrics.gapMd


        Item {
            width: parent.width
            height: Metrics.touchTarget
            Text {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                text: Qt.formatDate(root.anchor, "MMMM yyyy")
                font.family: Typography.family
                font.pixelSize: Typography.sizeMd
                font.weight: Typography.weightSemibold
                color: Colors.fg
            }
            Row {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                spacing: Metrics.gapXs
                JeriButton {
                    glyph: "chevron_left"
                    color: Colors.fgMuted
                    onClicked: root.prevMonth()
                }
                JeriButton {
                    glyph: "chevron_right"
                    color: Colors.fgMuted
                    onClicked: root.nextMonth()
                }
            }
        }


        Row {
            width: parent.width
            spacing: Metrics.gapXs
            Repeater {
                model: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
                Text {
                    width: (parent.width - 6 * parent.spacing) / 7
                    horizontalAlignment: Text.AlignHCenter
                    text: modelData
                    font.family: Typography.family
                    font.pixelSize: Typography.sizeXs
                    color: Colors.fgFaint
                }
            }
        }


        Grid {
            id: grid
            columns: 7
            spacing: Metrics.gapXs
            width: parent.width
            Repeater {
                model: root.cells
                delegate: Item {
                    readonly property var cell: modelData
                    width: (grid.width - 6 * grid.spacing) / 7
                    height: Metrics.touchTarget

                    Rectangle {
                        anchors.fill: parent
                        radius: Metrics.radiusSm
                        color: Colors.accentSoft
                        opacity: cell.isToday ? 0.5 : 0
                        visible: cell.inMonth
                    }
                    Rectangle {
                        anchors.fill: parent
                        radius: Metrics.radiusSm
                        color: "transparent"
                        border.color: cell.isToday ? Colors.accent : "transparent"
                        border.width: Metrics.borderWidth
                        visible: cell.inMonth
                    }
                    Text {
                        anchors.centerIn: parent
                        text: cell.inMonth ? cell.day : ""
                        font.family: Typography.family
                        font.pixelSize: Typography.sizeSm
                        font.weight: cell.isToday ? Typography.weightSemibold : Typography.weightNormal
                        color: cell.inMonth ? (cell.isToday ? Colors.accent : Colors.fg)
                                             : "transparent"
                    }
                    MouseArea {
                        anchors.fill: parent
                        visible: cell.inMonth
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.dayPicked(cell.d)
                    }
                }
            }
        }
    }

    Keys.onPressed: function(event) {
        if (event.key === Qt.Key_Left) { root.prevMonth(); event.accepted = true }
        else if (event.key === Qt.Key_Right) { root.nextMonth(); event.accepted = true }
        else if (event.key === Qt.Key_Home) { root.goToday(); event.accepted = true }
    }
}