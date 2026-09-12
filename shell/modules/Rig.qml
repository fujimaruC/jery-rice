import QtQuick
import "../theme"




Item {
    id: rig

    property var modelData

    Bar {
        id: bar
        screen: modelData

        onOpenDashboard: dashboard.setOpen(!dashboard.open)
        onOpenControl: ccp.setOpen(!ccp.open)
        onOpenLauncher: launcher.open()
        onCapsuleClicked: dashboard.setOpen(true)
    }

    Dashboard {
        id: dashboard
        screen: modelData
    }

    ControlCenter {
        id: ccp
        screen: modelData
    }

    Launcher {
        id: launcher
        screen: modelData
    }

    Notifications {
        id: toasts
        screen: modelData
    }
}