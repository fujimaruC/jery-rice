import QtQuick
import QtQuick.Controls
import "../theme"





StackAnimation {
    id: root

    property int direction: 1

    add: Transition {
        NumberAnimation { property: "opacity"; from: 0; to: 1; duration: Motion.normal; easing.type: Motion.easeOut }
        NumberAnimation { property: "x"; from: root.direction * 12; to: 0; duration: Motion.normal; easing.type: Motion.easeOut }
    }
    addDisplace: Transition {
        NumberAnimation { property: "x"; duration: 0 }
    }
    remove: Transition {
        NumberAnimation { property: "opacity"; from: 1; to: 0; duration: Motion.fast; easing.type: Motion.easeIn }
        NumberAnimation { property: "x"; to: -root.direction * 12; duration: Motion.fast; easing.type: Motion.easeIn }
    }
    removeDisplace: Transition {
        NumberAnimation { property: "x"; duration: 0 }
    }
}