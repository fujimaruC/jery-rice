pragma Singleton
import QtQuick
import Quickshell.Services.Notifications

Item {



    NotificationServer {
        id: server
        bodySupported: true
        bodyMarkupSupported: true
        imageSupported: true
        actionsSupported: true
        persistenceSupported: true
    }

    readonly property var tracked: server.trackedNotifications
    readonly property bool active: server.trackedNotifications !== null
        && server.trackedNotifications.values.length > 0

    function has() { return tracked !== null && tracked.values.length > 0 }
    function dismiss(n) { if (n) n.dismiss() }
    function invoke(n) { if (n) n.invoke() }
}