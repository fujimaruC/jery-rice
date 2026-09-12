pragma Singleton
import QtQuick
import Quickshell.Networking

Item {



    readonly property var devices: Networking.devices

    readonly property var active: {
        if (!Networking.devices) return null
        var vals = Networking.devices.values
        if (!vals || vals.length === 0) return null
        for (var i = 0; i < vals.length; i++) {
            var d = vals[i]
            if (d && d.connected && d.type !== DeviceType.Loopback) return d
        }
        return null
    }


    readonly property var wired: active !== null && active.type === DeviceType.Ethernet ? active : null
    readonly property var wifi:  active !== null && active.type === DeviceType.Wifi ? active : null

    function refresh() { Networking.checkConnectivity() }
}