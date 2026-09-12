import Quickshell
import QtQuick
import "theme"
import "services"
import "modules"





ShellRoot {
    id: root


    Binding { target: Motion; property: "visualMode"; value: ShellState.visualMode }
    Binding { target: Motion; property: "reducedMotion"; value: ShellState.reducedMotion }

    Variants {
        model: Quickshell.screens
        delegate: Component {
            Rig {
                screen: modelData
            }
        }
    }

    property bool exitRequested: false
}